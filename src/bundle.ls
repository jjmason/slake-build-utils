/** bundle.ls --- Bundles modules into Browserify require-able thingies
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


## Module slake-build-utils.bundle #####################################



### == Dependencies ====================================================
browserify = require \browserify



### == Helpers =========================================================

#### Function browserify-require
# Adds a module to the bundle.
#
# browserify-require :: BrowserifyBundle -> String -> IO ()
# browserify-require :: BrowserifyBundle -> { String -> String } -> IO ()
browserify-require(bundle, module) =
  | typeof module is \string => bundle.require module
  | otherwise                => for target, path of module
                                  bundle.require path, target: "/node_modules/#target/index.js"



### == Core implementation =============================================

#### Function bundle
# Generates a browserify bundle with the given options.
#
# bundle :: BundleOptions -> [String] -> BrowserifyBundle
bundle(options = {+bare, -prelude}, entries) =
  b = browserify cache: options.cache, debug: options.debug, exports: options.exports
  b.register \.ls compile options

  if (not options.prelude) => do
                              b.files    = []
                              b.prepends = []

  each ((k, v) -> b.alias v, k), options.aliases ? {}
  each b.ignore                , options.ignore  ? []
  each (browserify-require b)  , options.require ? []
  each (b.add-entry            , entries         ? []

  b



### Exports ############################################################
module.exports = {
  bundle
}