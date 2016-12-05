import threadpool
const str = ["Enjoy", "Rosetta", "Code"]

proc f(i) {.thread.} =
  echo str[i]

for i in 0..str.high:
  spawn f(i)
sync()
