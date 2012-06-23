utils    = require \./src
fs       = require \./src/fs
glob     = require \glob .sync

global <<< require \prelude-ls
(require \coloured) .extendString!


defaults    = void
environment =
  package: require \./package.json


as-js = fs.with-extension '.js'

errors = []

build = (file) ->
  source = fs.read "src/#file"
  console.log "—› Compiling `#file'"
  try
    source |> utils.compile defaults          \
           |> utils.expand-macros environment \
           |> fs.write (as-js "lib/#file")
    console.log "—› `#file' compiled successfully.".green!
  catch e
    console.log "#{errors.push ['build <' + file + '>' e]}) Failed to compile `#file'".red!


display-errors = ->
  unless empty errors
    console.log "\n" + ("=" * 72).red!
    console.log "There were errors while running the build tasks:\n\n".red!
    for e, i in errors
      [task, error] = e
      console.log "#{i + 1}) at #task:\n#{error.stack}\n".red!


task \clean 'Removes all build artifacts.' ->
  fs.remove \lib
  fs.remove \dist


task \build 'Builds JavaScript files out of the LiveScript ones.' ->
  fs.initialise \lib
  each build, glob '**/*.ls', cwd: 'src'
  display-errors!