import locks, os, strformat

type Semaphore = object
  lock: Lock
  cond: Cond
  maxCount: int
  currCount: int

var
  sem: Semaphore
  running = true

proc init(sem: var Semaphore; maxCount: Positive) =
  sem.lock.initLock()
  sem.cond.initCond()
  sem.maxCount = maxCount
  sem.currCount = maxCount

proc count(sem: var Semaphore): int =
  sem.lock.acquire()
  result = sem.currCount
  sem.lock.release()

proc acquire(sem: var Semaphore) =
  sem.lock.acquire()
  while sem.currCount == 0:
    sem.cond.wait(sem.lock)
  dec sem.currCount
  sem.lock.release()

proc release(sem: var Semaphore) =
  sem.lock.acquire()
  if sem.currCount < sem.maxCount:
    inc sem.currCount
  sem.lock.release()
  sem.cond.signal()

proc close(sem: var Semaphore) =
  sem.lock.deinitLock()
  sem.cond.deinitCond()

proc task(id: int) {.thread.} =
  echo &"Task {id} started."
  while running:
    sem.acquire()
    echo &"Task {id} acquired semaphore."
    sleep(2000)
    sem.release()
    echo &"Task {id} released semaphore."
    sleep(100)    # Give time to other tasks.
  echo &"Task {id} terminated."

proc stop() {.noconv.} = running = false


var threads: array[10, Thread[int]]

sem.init(4)
setControlCHook(stop)   # Catch control-C to terminate gracefully.

for n in 0..9: createThread(threads[n], task, n)
threads.joinThreads()
sem.close()
