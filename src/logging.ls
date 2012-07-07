/** logging.ls --- Logging and debugging utilities
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


## Module slake-build-utils.logging ####################################



### == Dependencies ====================================================
Colour = require \coloured



### == Helpers =========================================================
errors   = []
err-logs = 0



### == Core implementation =============================================

#### Function colourise
# Applies the given foreground colour to the message.
#
# colourise :: ColourName -> String -> String
colourise(colour, message) =
  Colour.colourise message, foreground: colour


#### Function colourise2
# Applies the given foreground and background colour to the message.
#
# colourise2 :: ColourName -> ColourName -> String -> String
colourise2(colour, bg, message) =
  Colour.colourise message, foreground: colour, background: bg


#### Function colour-effect
# Applies the given colour effect to the message.
#
# colour-effect :: EffectName -> String -> String
colour-effect(effect, message) =
  Colour.colourise message, extra: effect



#### Function header
# Displays a header on the standard output.
#
# header :: String -> IO ()
header = (message) ->
  message += " " * (72 - message.length)
  console.log (colours.white_on_cyan message)


#### Function horizontal-line
# Displays an horizontal line on the standard output.
#
# horizontal-line :: ColourName? -> String
horizontal-line = (colour = \none) ->
  console.log "\n" + (colourise colour, "=" * 72)


#### Function log-error
# Adds the error to the error log, which can be later on displayed.
#
# log-error :: String -> [String] -> Error -> String -> IO ()
log-error(kind, params, error, message) =
  kind = "#kind <#{params.join ', '}>"
  errors.push [kind, error]
  console.error (red "#{++err-logs}) #message")


#### Function display-errors
# Displays previously logged errors and clears the log queue.
#
# display-errors :: () -> IO ()
display-errors = ->
  unless empty errors
    horizontal-line \white
    console.log "There were errors while running the build tasks:\n"
    for e, i in errors
      [task, error] = e
      console.log (red "#{i + (err-logs - errors.length) + 1}) at #task:")
      console.log error.stack, "\n"
    errors := []



### == Colour aliases ==================================================

# Generates colours aliases for every possible combination.
#
# This means colours are available as both ``<foreground>`` (e.g.:
# ``red``, ``white``) and ``<foreground>_on_<background>`` (e.g.:
# ``black_on_white``).
#
# Effects are available as ``fx_<effect>`` (e.g.: ``fx_bold``).
colours = {}
for fg of Colour.colours
  colours[fg] = colourise fg
  for bg of Colour.colours
    colours["#{fg}_on_#{bg}"] = colourise2 fg, bg

for extra of Colour.extras
  colours["fx_#extra"] = colour-effect extra

red = colourise \red



### Exports ############################################################
module.exports = {
  header
  horizontal-line
  log-error
  display-errors
  colourise
  colourise2
  colour-effect
} <<< colours