/** compile.ls --- Compiles LiveScript into JavaScript
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


## Module slake-build-utils.compile ####################################


### == Interfaces ======================================================

#### Interface LiveScriptOptions
#
# bare :: Boolean


#### Interface UglifyOptions
#
# toplevel      :: Boolean
# except        :: Boolean
# defines       :: Boolean
# make_seqs     :: Boolean
# dead_code     :: Boolean
# beautify      :: Boolean
# indent_start  :: Number
# indent_level  :: Number
# quote_keys    :: Boolean
# space_colon   :: Boolean
# ascii_only    :: Boolean
# inline_script :: Boolean


#### Interface Pathname
#
# :: String


### == Dependencies ====================================================
live-script      = require \LiveScript
{parser, uglify} = require \uglify-js
log              = require \./logging
fs               = require \./fs



### == Aliases =========================================================
parse                       = parser.parse
mangle-ast(options, ast)    = uglify.ast_mangle ast, options
lift-variables              = uglify.ast_lift_variables
squeeze-ast(options, ast)   = uglify.ast_squeeze ast, options
generate-code(options, ast) = uglify.gen_code ast, options



### == Core implementation =============================================

#### Function build
# Compiles the file using the given processing function.
#
# build :: Pathname -> (String -> IO String) -> Pathname -> IO String
build(source-dir, process, file) =
  log.header "—› Compiling `#file'."
  try
    result = process file
    fs.read "#sourceDir/#file" |> result
    console.log (log.green "—› `#file' compiled successfully.")
    result
  catch e
    log.log-error \build, [file], e, "Failed to compile `#file'.'"


#### Function compile
# Compiles a String of LiveScript source.
#
# compile :: LiveScriptOptions -> String -> String
compile(options = {+bare}, source) =
  live-script.compile source, options


#### Function minify
# Optimises JavaScript code for minimal network overhead.
#
# minify :: UglifyOptions -> String -> String
minify(options = {}, source) = do
                               source |> parse
                                      |> lift-variables
                                      |> mangle-ast options
                                      |> squeeze-ast options
                                      |> generate-code options



### Exports ############################################################
module.exports = {
  build
  compile
  minify
}