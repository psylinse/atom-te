{CompositeDisposable} = require 'atom'
ChildProcess = require 'child_process'

module.exports = AtomTe =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-te:runLine': => @runLine()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-te:runFile': => @runFile()

  deactivate: ->
    @subscriptions.dispose()

  currentFile: ->
    editor = atom.workspace.getActiveEditor()
    return unless editor?

    editor.getPath()

  runFile: ->
    @run(@currentFile())

  runLine: ->
    editor = atom.workspace.getActiveEditor()

    line = editor.getCursor().getBufferRow() + 1
    @run("#{@currentFile()}:#{line}")

  run: (args) ->
    spawn = ChildProcess.spawn
    testCommand = "te run"
    command = "#{testCommand} #{args}"
    console.log "[Te] running: #{command}"
    terminal = spawn("bash", ["-l"])

    terminal.stdin.write("cd #{@projectRoot()} && #{command}\n")
    terminal.stdin.write("exit\n")

  projectRoot: ->
    atom.project.getRootDirectory().getPath()
