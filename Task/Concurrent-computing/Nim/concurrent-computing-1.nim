const str = ["Enjoy", "Rosetta", "Code"]

var thr: array[3, TThread[int32]]

proc f(i) {.thread.} =
  echo str[i]

for i in 0..thr.high:
  createThread(thr[i], f, int32(i))
joinThreads(thr)
