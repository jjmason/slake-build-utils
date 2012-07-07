/** packaging.ls --- Generates tar/zip packages.
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


## Module slake-build-utils.packaging ##################################
{run} = require './shell'



### == Core implementation =============================================

#### Function tar
# Generates a plain tarball with the given files.
#
# tar :: ProcessOptions -> Pathname -> [Pathname] -> ProcessExecution
tar(options = {}, filename, files) =
  run [\tar \-cf "#filename.tar"] +++ files, options


#### Function tar-gz
# Generates a gzipped tarball with the given files.
#
# tar-gz :: ProcessOptions -> Pathname -> [Pathname] -> ProcessExecution
targz(options = {}, filename, files) =
  run [\tar \-czf "#filename.tar.gz"] +++ files, options


#### Function zip
# Generates a zip package with the given files.
#
# zip :: ProcessOptions -> Pathname -> [Pathname] -> ProcessExecution
zip(options = {}, filename, files) =
  run [\tar \-r "#filename.zip"] +++ files, options



### Exports ############################################################
module.exports = {
  tar
  tar-gz
  zip
}