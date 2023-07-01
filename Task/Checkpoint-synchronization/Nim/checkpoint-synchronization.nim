import locks
import os
import random
import strformat

const
  NWorkers = 3    # Number of workers.
  NTasks = 4      # Number of tasks.
  StopOrder = 0   # Order 0 is the request to stop.

var
  randLock: Lock                              # Lock to access random number generator.
  orders: array[1..NWorkers, Channel[int]]    # Channel to send orders to workers.
  responses: Channel[int]                     # Channel to receive responses from workers.
  working: int                                # Current number of workers actually working.
  threads: array[1..NWorkers, Thread[int]]    # Array of running threads.

#---------------------------------------------------------------------------------------------------

proc worker(num: int) {.thread.} =
  ## Worker thread.

  while true:
    # Wait for order from main thread (this is the checkpoint).
    let order = orders[num].recv
    if order == StopOrder: break
    # Get a random time to complete the task.
    var time: int
    withLock(randLock): time = rand(200..1000)
    echo fmt"Worker {num}: starting task number {order}"
    # Work on task during "time" ms.
    sleep(time)
    echo fmt"Worker {num}: task number {order} terminated after {time} ms"
    # Send message to indicate that the task is terminated.
    responses.send(num)

#---------------------------------------------------------------------------------------------------

# Initializations.
randomize()
randLock.initLock()
for num in 1..NWorkers:
  orders[num].open()
responses.open()

# Create the worker threads.
for num in 1..NWorkers:
  createThread(threads[num], worker, num)

# Send orders and wait for responses.
for task in 1..NTasks:
  echo fmt"Sending order to start task number {task}"
  # Send order (task number) to workers.
  for num in 1..NWorkers:
    orders[num].send(task)
  working = NWorkers          # All workers are now working.
  # Wait to receive responses from workers.
  while working > 0:
    discard responses.recv()  # Here, we don't care about the message content.
    dec working

# We have terminated: send stop order to workers.
echo "Sending stop order to workers."
for num in 1..NWorkers:
  orders[num].send(StopOrder)
joinThreads(threads)
echo "All workers stopped."

# Clean up.
for num in 1..NWorkers:
  orders[num].close()
responses.close()
deinitLock(randLock)
