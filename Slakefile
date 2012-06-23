_    = require \./src
fs   = _.fs
glob = require \glob .sync

global <<< require \prelude-ls


defaults    = void
environment =
  package: require \./package.json


as-js = fs.with-extension '.js'

errors = []

build = _.build \src (file, source) -->
  source |> _.compile defaults           \
         |> _.expand-macros environment  \
         |> fs.write (as-js "lib/#file")


task \clean 'Removes all build artifacts.' ->
  fs.remove \lib
  fs.remove \dist


task \build 'Builds JavaScript files out of the LiveScript ones.' ->
  fs.initialise \lib
  each build, glob '**/*.ls', cwd: 'src'
  _.display-errors!