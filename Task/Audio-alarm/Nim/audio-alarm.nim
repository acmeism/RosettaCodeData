import os, strutils, terminal

var delay: int
while true:
  stdout.write "Enter delay in seconds: "
  stdout.flushFile()
  try:
    delay = stdin.readLine.strip().parseInt()
    break
  except ValueError:
    echo "Error: invalid value."
  except EOFError:
    echo()
    quit "Quitting.", QuitFailure

var filename: string
while true:
  stdout.write "Enter mp3 file name (without extension): "
  stdout.flushFile()
  try:
    filename = stdin.readLine
    break
  except EOFError:
    echo ()
    quit "Quitting.", QuitFailure

stdout.eraseScreen()
echo "Alarm will sound in $# second(s)...".format(delay)
os.sleep delay * 1000
stdout.eraseScreen()
if execShellCmd("play $#.mp3" % filename) != 0:
  echo "Error while playing mp3 file."
