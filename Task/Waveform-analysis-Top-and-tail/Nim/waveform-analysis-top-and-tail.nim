import os, osproc, strutils

const Sec = "00:00:01"

proc getString(prompt: string): string =
  while true:
    stdout.write prompt
    stdout.flushFile()
    try:
      result = stdin.readLine().strip()
      if result.len != 0: break
    except EOFError:
      quit "\nEOF encountered. Quitting.", QuitFailure

proc getFloatValue(prompt: string; minval, maxval: float): float =
  while true:
    stdout.write prompt
    stdout.flushFile()
    try:
      result = stdin.readLine.strip().parseFloat()
      if result notin minval..maxval:
        echo "Invalid value"
      else:
        return
    except ValueError:
      echo "Error: invalid value."
    except EOFError:
      quit "\nEOF encountered. Quitting.", QuitFailure

let infile = getString("Enter name of audio file to be trimmed: ")
let outfile = getString("Enter name of output file: ")
let squelch = getFloatValue("Enter squelch level % max (1 to 10): ", 1, 10)
let squelchS = squelch.formatFloat(ffDecimal, precision = -1) & '%'

let tmp1 = "tmp1_" & infile
let tmp2 = "tmp2_" & infile

# Trim audio below squelch level from start and output to tmp1.
var args = @[infile, tmp1, "silence", "1", Sec, squelchS]
discard execProcess("sox", args = args, options = {poStdErrToStdOut, poUsePath})

# Reverse tmp1 to tmp2.
args = @[tmp1, tmp2, "reverse"]
discard execProcess("sox", args = args, options = {poStdErrToStdOut, poUsePath})

# Trim audio below squelch level from tmp2 and output to tmp1.
args = @[tmp2, tmp1, "silence", "1", Sec, squelchS]
discard execProcess("sox", args = args, options = {poStdErrToStdOut, poUsePath})

# Reverse tmp1 to the output file.
args = @[tmp1, outfile, "reverse"]
discard execProcess("sox", args = args, options = {poStdErrToStdOut, poUsePath})

# Remove the temporary files.
removeFile(tmp1)
removeFile(tmp2)
