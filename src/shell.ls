/** shell.ls --- Executes applications using the shell
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


## Module slake-build-utils.shell ######################################



### == Dependencies ====================================================
{spawn}   = require \child_process
{Promise} = require \casie



### == Interfaces ======================================================

#### Interface ProcessStatus
#
# :: Either () Error

#### Interface ProcessExecution
#
# process :: ChildProcess
# promise :: Promise ProcessStatus


#### Interface ProcessOptions
#
# cwd    :: String
# env    :: { String -> String }
# stdout :: Stream
# stdin  :: Stream
# stderr :: Stream


### == Core implementation =============================================

#### Function run
# Executes a shell command asynchronously.
#
# Example::
#
#     {p1:process} = run <[ grep bar ]>
#     {p2:process} = run <[ ls -la ]> pipe-output: p1
#
# run :: [String], ProcessOptions -> ProcessExecution
run = ([command, args], options = {stdout: process.stdout, stderr: process.stdout}) ->
  promise = Promise.make!
  ps      = spawn command, args, options

  if options.stdout => ps.stdout.pipe options.stdout
  if options.stderr => ps.stderr.pipe options.stderr
  if options.stdin  => do
                       ps.stdin.resume!
                       options.stdin.pipe ps.stdin

  ps.on \exit (code) ->
    | code is 0 => promise.bind!
    | otherwise => promise.fail (Error "Process #command exited with code: #code.")

  process: ps
  promise: promise



### Exports ############################################################
module.exports = {
  run
}