/** pack.ls --- Generate packages for distribution
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


## Module slake-build-utils.pack #######################################
module.exports = (name = 'dist', output-dir = 'dist', filename, files) -->

  
  ### == Dependencies ====================================================
  log = require '../logging'
  package = require '../packaging'
  sequentially = require 'cassie/src/sequencing'


  
  ### == Core implementation =============================================
  task name, 'Generates a distribution package.' ->
    log.header "→ Generating package `#filename'."
    fs.make output-dir
    sequentially (-> package.tar-gz {cwd: output-dir} "#filename" files) \
               , (-> package.zip {cwd: output-dir} "#filename" files)
      .ok     -> console.log (_.green ":: Package `#filename' generated successfully.")
      .failed -> log.log-error \package, [filename], (Error it), "Failed to generate packages for `#filename'."