import os, times, strutils

if paramCount() == 0:
  try: stdout.write readFile("notes.txt")
  except IOError: discard
else:
  var f = open("notes.txt", fmAppend)
  f.writeLine getTime()
  f.writeLine "\t", commandLineParams().join(" ")
  f.close()
