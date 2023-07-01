import threadpool, locks, math, os, random
# to call randomize() as a seed, need to import random module
randomize()

type Philosopher = ref object
  name: string
  food: string
  forkLeft, forkRight: int

const
  n = 5
  names = ["Aristotle", "Kant", "Spinoza", "Marx", "Russell"]
  foods = [" rat poison", " cockroaches", " dog food", " lemon-curd toast", " baked worms"]

var
  forks: array[n, Lock]
  phils: array[n, Philosopher]
  threads: array[n, Thread[Philosopher]]

proc run(p: Philosopher) {.thread.} =
  # random deprecated, use rand(x .. y)
  sleep rand(1..10) * 500
  echo p.name, " is hungry."

  acquire forks[min(p.forkLeft, p.forkRight)]
  sleep rand(1..5) * 500
  acquire forks[max(p.forkLeft, p.forkRight)]

  echo p.name, " starts eating", p.food, "."
  sleep rand(1..10) * 500

  echo p.name, " finishes eating", p.food, " and leaves to think."

  release forks[p.forkLeft]
  release forks[p.forkRight]

for i in 0..<n:
  initLock forks[i]
  phils[i] = Philosopher(
    name: names[i],
    food: foods[rand(0 .. n) mod n],
    forkLeft: i,
    forkRight: (i + 1) mod n
  )
  createThread(threads[i], run, phils[i])

joinThreads(threads)
