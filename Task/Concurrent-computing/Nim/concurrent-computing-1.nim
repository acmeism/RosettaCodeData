const str = ["Enjoy", "Rosetta", "Code"]

var thr: array[3, Thread[int32]]

proc f(i:int32) {.thread.} =
  echo str[i]

for i in 0..thr.high:
  createThread(thr[i], f, int32(i))
joinThreads(thr)
