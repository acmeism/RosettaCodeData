import os
const directories = ["/", "./"]
for directory in directories:
  open(directory & "output.txt", fmWrite).close()
  createDir(directory & "docs")
