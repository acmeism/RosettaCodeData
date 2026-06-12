import osproc, strutils

proc getIntValue(msg: string; minval, maxval: int): int =
  while true:
    stdout.write msg
    stdout.flushFile()
    try:
      result = stdin.readLine.strip().parseInt()
      if result notin minval..maxval:
        echo "Invalid value"
      else:
        return
    except ValueError:
      echo "Error: invalid value."
    except EOFError:
      echo()
      quit "Quitting.", QuitFailure

let freq = getIntValue("Enter frequency in Hz (40 to 10000): ", 40, 10_000)
let duration = 5
let kind = "sine"
let args = ["-n", "synth", $duration, $kind, $freq]
echo execProcess("play", args = args, options = {poStdErrToStdOut, poUsePath})
