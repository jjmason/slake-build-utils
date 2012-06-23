slake-build-utils
=================

These utilities allow you to write moar concise Slakefiles, by providing some
common build utilities as a reusable library.


### Example

```coffee
utils = require 'utils'
fs    = require 'utils/src/fs'
glob  = require 'glob' .sync

defaults    = void
environment =
  package: require './package.json'


task \build 'Builds JavaScript files out of LiveScript ones.' ->
  fs.initialise \lib
  for file in glob '**/*.ls', cwd: 'src'
    fs.read "src/#file" |> utils.compile defaults            \
                        |> utils.expand-macros environment   \
                        |> fs.write (fs.as-js "lib/#file")   \
                        |> utils.minify defaults             \
                        |> fs.write (fs.as-min "lib/#file")
```


### Installation

Just grab it from NPM:

    $ npm install -d slake-build-utils
    

### Building

To compile everything from the source, you'll need [LiveScript][]. Once you've
installed that, just run the Slake `build` task, which should generate all the
JavaScript files in the `lib` directory:

    $ npm install -gd LiveScript
    $ git clone git://github.com/killdream/slake-build-utils.git
    $ cd slake-build-utils
    $ npm install -d
    $ slake build
    

### Licence

Slake-build-utils is licensed under the delicious and permissive [MIT][]
licence. You can happily copy, share, modify, sell or whatever — refer to the
actual licence text for `less` information:

    $ less LICENCE.txt
    
    
[MIT]: https://github.com/killdream/slake-build-utils/raw/master/LICENCE.txt
