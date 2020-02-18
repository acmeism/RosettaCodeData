import os, sequtils

proc isEmptyDir(dir: string): bool =
  toSeq(walkdir dir).len == 0

echo isEmptyDir("/tmp")  # false - there is always something in "/tmp"
echo isEmptyDir("/temp") # true  - "/temp" does not exist
