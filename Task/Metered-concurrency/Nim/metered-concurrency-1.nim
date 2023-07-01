import os, posix, strformat

type SemaphoreError = object of CatchableError

var
  sem: Sem
  running = true

proc init(sem: var Sem; count: Natural) =
  if sem_init(sem.addr, 0, count.cint) != 0:
    raise newException(SemaphoreError, "unable to initialize semaphore")

proc count(sem: var Sem): int =
  var c: cint
  if sem_getvalue(sem.addr, c) != 0:
    raise newException(SemaphoreError, "unable to get value of semaphore")
  result = c

proc acquire(sem: var Sem) =
  if sem_wait(sem.addr) != 0:
    raise newException(SemaphoreError, "unable to acquire semaphore")

proc release(sem: var Sem) =
  if sem_post(sem.addr) != 0:
    raise newException(SemaphoreError, "unable to get release semaphore")

proc close(sem: var Sem) =
  if sem_destroy(sem.addr) != 0:
    raise newException(SemaphoreError, "unable to close the semaphore")

proc task(id: int) {.thread.} =
  echo &"Task {id} started."
  while running:
    sem.acquire()
    echo &"Task {id} acquired semaphore. Count is {sem.count()}."
    sleep(2000)
    sem.release()
    echo &"Task {id} released semaphore. Count is {sem.count()}."
    sleep(100)    # Give time to other tasks.
  echo &"Task {id} terminated."

proc stop() {.noconv.} = running = false


var threads: array[10, Thread[int]]

sem.init(4)
setControlCHook(stop)   # Catch control-C to terminate gracefully.

for n in 0..9: createThread(threads[n], task, n)
threads.joinThreads()
sem.close()
