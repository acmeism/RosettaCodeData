import strutils

var lines = stdin.readAll()
for line in lines.split("\n"):
  echo line
