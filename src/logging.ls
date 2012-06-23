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
errors = []


### == Core implementation =============================================
colourise(colour, message) =
  Colour.colourise message, foreground: colour


colourise2(colour, bg, message) =
  Colour.colourise message, foreground: colour, background: bg

colour-effect(effect, message) =
  Colour.colourise message, extra: effect


colours = {}
for fg of Colour.colours
  colours[fg] = colourise fg
  for bg of Colour.colours
    colours["#{fg}_on_#{bg}"] = colourise2 fg, bg

for extra of Colour.extras
  colours["fx_#extra"] = colour-effect extra


red  = colourise \red


header = (message) ->
  message += " " * (72 - message.length)
  console.log (colours.white_on_cyan message)


horizontal-line = (colour = \none) ->
  console.log (colourise colour, 72 * "=")


log-error(kind, params, error, message) =
  kind = "#kind <#{params.join ', '}>"
  errors.push [kind, error]
  console.error (red "#{errors.length}) #message")


display-errors = ->
  unless empty errors
    horizontal-line red
    console.log (red "There were errors while running the build tasks:\n\n")
    for e, i in errors
      [task, error] = e
      console.log (red "#{i + 1}) at #task:")
      console.log error.stack, "\n"


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