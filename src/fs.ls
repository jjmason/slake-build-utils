/** fs.ls --- Common directory operations
 *
 * Version: -:package.version:-
 *
 * Copyright (c) 2012 Quildreen Motta
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


## Module slake-build-utils.fs #########################################

### == Dependencies ====================================================
fs     = require \fs
path   = require \path
wrench = require \wrench



### == Core implementation =============================================

#### Function exists-p
# Checks if a given path exists.
#
# exists? :: Pathname -> Boolean
exists-p = fs.exists-sync || path.exists-sync


#### Function make
# Creates a directory and all its parents. Does nothing if the given
# path already exists.
#
# make :: Pathname -> IO ()
make = wrench.mkdir-sync-recursive


#### Function remove
# Removes the file tree at the given path. That is, the directory and
# all its files/sub-directories.
#
# remove :: Pathname -> IO ()
remove = -> wrench.rmdir-sync-recursive it, true


#### Function copy
# Copies the ``source`` tree to the ``destination``.
#
# copy :: Pathname -> Pathname -> IO ()
copy(source, destination) = wrench.copy-dir-sync-recursive source, destination


#### Function initialise
# Initialises the directory at the given path. This will force the
# creation of the directory and ensure that it's empty.
#
# initialise :: Pathname -> IO ()
initialise = (path) ->
  remove path
  make path


#### Function read
# Returns the contents of the file at the given path, using utf-8
# encoding.
#
# read :: Pathname -> String
read = (file) -> fs.read-file-sync file, \utf-8


#### Function write
# Writes the given string to the file at the given path, using utf-8
# encoding.
#
# write :: Pathname -> String -> IO String
write(file, data) =
  fs.write-file-sync file, data, \utf-8
  data


#### Function with-extension
# Constructs a new pathname, changing the file's extension to the given
# one.
#
# with-extension :: String -> Pathname -> Pathname
with-extension(ext, file) =
  path.join (path.dirname file)
          , "#{path.basename file, path.extname file}#ext"


#### Function as-js
# Constructs a new pathname, changing the extension to ``.js``
#
# as-js :: Pathname -> Pathname
as-js = with-extension '.js'

#### Function as-min
# Constructs a new pathname, changing the extension to ``.min.js``
#
# as-min :: Pathname -> Pathname
as-min = with-extension '.min.js'

#### Function as-dbg
# Constructs a new pathname, changing the extension to ``.dbg.js``
#
# as-dbg :: Pathname -> Pathname
as-dbg = with-extension '.dbg.js'



### Exports ############################################################
module.exports = {
  initialise
  make
  remove
  copy

  # paths
  exists-p
  with-extension
  as-js
  as-min
  as-dbg

  # files
  read
  write
}
