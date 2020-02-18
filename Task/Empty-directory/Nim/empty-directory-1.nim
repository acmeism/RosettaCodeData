import os, rdstdin

var empty = true
for f in walkDir(readLineFromStdin "directory: "):
  empty = false
  break
echo empty
