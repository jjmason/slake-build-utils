/** tasks.ls --- Ready-to-use parametrised build tasks
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


## Module slake-build-utils.tasks ######################################

### == Dependencies ====================================================
glob                     = require \glob .sync

{compile, build, minify} = require \./compile
{expand-macros}          = require \./process
fs                       = require \./fs


### == Core implementation =============================================
compile-ls(source-dir, output-dir, options) =
  make = build source-dir, (file, source) -->
    source |> compile options.compile               \
           |> expand-macros options.environment     \
           |> fs.write (fs.as-js "#outputDir/#file")

  fs.initialise output-dir
  for file in glob '**/*.ls', cwd: source-dir => make file





### Exports ############################################################
module.exports = {
  compile-ls
}