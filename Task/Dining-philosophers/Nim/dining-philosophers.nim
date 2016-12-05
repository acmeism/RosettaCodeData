import threadpool, locks, math, os
randomize()

type Philosopher = ref object
  name: string
  forkLeft, forkRight: int

const
  n = 5
  names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell"]

var
  forks: array[n, TLock]
  phils: array[n, Philosopher]
  threads: array[n, TThread[Philosopher]]

proc run(p: Philosopher) {.thread.} =
  sleep random(1 .. 10) * 500
  echo p.name, " is hungry."

  acquire forks[min(p.forkLeft, p.forkRight)]
  sleep random(1 .. 5) * 500
  acquire forks[max(p.forkLeft, p.forkRight)]

  echo p.name, " starts eating."
  sleep random(1 .. 10) * 500

  echo p.name, " finishes eating and leaves to think."

  release forks[p.forkLeft]
  release forks[p.forkRight]

for i in 0 .. <n:
  initLock forks[i]
  phils[i] = Philosopher(
    name: names[i],
    forkLeft: i,
    forkRight: (i+1) mod n)
  threads[i].createThread run, phils[i]

threads.joinThreads
