import locks
from os import sleep
import times
from strformat import fmt

var
  # condition variable which shared across threads
  cond: Cond
  lock: Lock
  threadproc: Thread[void]

proc waiting {.thread.} =
  echo "spawned waiting proc"
  let start = getTime()
  cond.wait lock
  echo fmt"thread ended after waiting {getTime() - start}."

proc main =
  initCond cond
  initLock lock
  threadproc.createThread waiting
  echo "in main proc"
  os.sleep 1000
  echo "send signal/event notification"
  signal cond
  joinThread threadproc
  deinitCond cond
  deinitLock lock

main()
