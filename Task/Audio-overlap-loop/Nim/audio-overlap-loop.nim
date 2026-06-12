import osproc, strutils

proc getValue[T: int | float](msg: string; minval, maxval: T): T =
  while true:
    stdout.write msg
    stdout.flushFile()
    try:
      result = when T is int: stdin.readLine.strip().parseInt()
               else: stdin.readLine.strip().parseFloat()
      if result notin minval..maxval:
        echo "Invalid value"
      else:
        return
    except ValueError:
      echo "Error: invalid value."
    except EOFError:
      echo()
      quit "Quitting.", QuitFailure

const FileName = "loop.wav"
let reps = getValue("Enter number of repetitions (1 to 6): ", 1, 6)
let delay = getValue("Enter delay between repetitions in microseconds (50 to 500): ", 50, 500)
let decay = getValue("Enter decay between repetitions (0.2 to 0.9): ", 0.2, 0.9)

var args = @[FileName, "echo", "0.8", "0.7"]
var decay2 = 1.0
for i in 1..reps:
  decay2 *= decay
  args.add $(i * delay)
  args.add $decay2
echo execProcess("play", args = args, options = {poStdErrToStdOut, poUsePath})
