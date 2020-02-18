import os, posix

let fn = getHomeDir() & "rosetta-code-lock"
proc ooiUnlink {.noconv.} = discard unlink fn

proc onlyOneInstance =
  var fl = TFlock(lType: F_WRLCK.cshort, lWhence: SEEK_SET.cshort)
  var fd = getFileHandle fn.open fmReadWrite
  if fcntl(fd, F_SETLK, addr fl) < 0:
    stderr.writeln "Another instance of this program is running"
    quit 1
  addQuitProc ooiUnlink

onlyOneInstance()

for i in countdown(10, 1):
  echo i
  sleep 1000
echo "Fin!"
