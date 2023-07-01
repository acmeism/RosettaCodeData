import os, strutils

proc single(n: int) =
  sleep n
  echo n

proc main =
  var thr = newSeq[TThread[int]](paramCount())
  for i,c in commandLineParams():
    thr[i].createThread(single, c.parseInt)
  thr.joinThreads

main()
