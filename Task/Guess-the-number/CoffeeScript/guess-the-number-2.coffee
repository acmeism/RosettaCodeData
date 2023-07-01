# This shows how to do simple REPL-like I/O in node.js.
readline = require "readline"

do ->
  number = Math.ceil(10 * Math.random())
  interface = readline.createInterface process.stdin, process.stdout

  guess = ->
    interface.question "Guess the number between 1 and 10: ", (answer) ->
      if parseInt(answer) == number
        # These lines allow the program to terminate.
        console.log "GOT IT!"
        interface.close()
        process.stdin.destroy()
      else
        console.log "Sorry, guess again"
        guess()

  guess()
