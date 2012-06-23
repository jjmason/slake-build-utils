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


### == Aliases =========================================================
exists-p = fs.exists-sync || path.exists-sync
make     = wrench.mkdir-sync-recursive
remove   = -> wrench.rmdir-sync-recursive it, true
copy     = wrench.copy-dir-sync-recursive

### == Core implementation =============================================
initialise = (path) ->
  remove path
  make path


read = (file)    -> fs.read-file-sync file, \utf-8
write(file, data) =
  fs.write-file-sync file, data, \utf-8
  data

with-extension(ext, file) =
  path.join (path.dirname file)
          , "#{path.basename file, path.extname file}#ext"

as-js  = with-extension '.js'
as-min = with-extension '.min.js'
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
