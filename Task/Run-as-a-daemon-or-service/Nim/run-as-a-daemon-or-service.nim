import os, posix, strutils

let pid = fork()
if pid != 0:
  echo "Child process detached with pid $#".format(pid)
  quit QuitSuccess

let
  oldStdin = stdin
  oldStdout = stdout
  oldStderr = stderr

stdin = open("/dev/null")
stdout = open("/tmp/dmn.log", fmWrite)
stderr = stdout

oldStdin.close()
oldStdout.close()
oldStderr.close()

discard setsid()

import times
var t = now()
while now() < t + initDuration(seconds = 10):
  echo "timer running, $# seconds".format((now() - t).inSeconds)
  sleep(1000)
