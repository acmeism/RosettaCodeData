import locks
import math
import os
import random

const N = 10          # Number of buckets.
const MaxInit = 99    # Maximum initial value for buckets.

var buckets: array[1..N, Natural]       # Array of buckets.
var bucketLocks: array[1..N, Lock]      # Array of bucket locks.
var randomLock: Lock                    # Lock to protect the random number generator.
var terminate: array[3, Channel[bool]]  # Used to ask threads to terminate.

#---------------------------------------------------------------------------------------------------

proc getTwoIndexes(): tuple[a, b: int] =
  ## Get two indexes from the random number generator.

  result.a = rand(1..N)
  result.b = rand(2..N)
  if result.b == result.a: result.b = 1

#---------------------------------------------------------------------------------------------------

proc equalize(num: int) {.thread.} =
  ## Try to equalize two buckets.

  var b1, b2: int         # Bucket indexes.

  while true:

    # Select the two buckets to "equalize".
    withLock randomLock:
     (b1, b2) = getTwoIndexes()
    if b1 > b2: swap b1, b2       # We want "b1 < b2" to avoid deadlocks.

    # Perform equalization.
    withLock bucketLocks[b1]:
      withLock bucketLocks[b2]:
        let target = (buckets[b1] + buckets[b2]) div 2
        let delta = target - buckets[b1]
        inc buckets[b1], delta
        dec buckets[b2], delta

    # Check termination.
    let (available, stop) = tryRecv terminate[num]
    if available and stop: break

#---------------------------------------------------------------------------------------------------

proc distribute(num: int) {.thread.} =
  ## Redistribute contents of two buckets.

  var b1, b2: int         # Bucket indexes.
  var factor: float       # Ratio used to compute the new value for "b1".

  while true:

    # Select the two buckets for redistribution and the redistribution factor.
    withLock randomLock:
      (b1, b2) = getTwoIndexes()
      factor = rand(0.0..1.0)
    if b1 > b2: swap b1, b2       # We want "b1 < b2" to avoid deadlocks..

    # Perform redistribution.
    withLock bucketLocks[b1]:
      withLock bucketLocks[b2]:
        let sum = buckets[b1] + buckets[b2]
        let value = (sum.toFloat * factor).toInt
        buckets[b1] = value
        buckets[b2] = sum - value

    # Check termination.
    let (available, stop) = tryRecv terminate[num]
    if available and stop: break

#---------------------------------------------------------------------------------------------------

proc display(num: int) {.thread.} =
  ## Display the content of buckets and the sum (which should be constant).

  while true:
    for i in 1..N: acquire bucketLocks[i]
    echo buckets, "   Total = ", sum(buckets)
    for i in countdown(N, 1): release bucketLocks[i]
    os.sleep(1000)

    # Check termination.
    let (available, stop) = tryRecv terminate[num]
    if available and stop: break

#———————————————————————————————————————————————————————————————————————————————————————————————————

randomize()

# Initialize the buckets with a random value.
for bucket in buckets.mitems:
  bucket = rand(1..MaxInit)

# Initialize the locks.
randomLock.initLock()
for lock in bucketLocks.mitems:
  lock.initLock()

# Open the channels.
for c in terminate.mitems:
  c.open()

# Create and launch the threads.
var tequal, tdist, tdisp: Thread[int]
tequal.createThread(equalize, 0)
tdist.createThread(distribute, 1)
tdisp.createThread(display, 2)

sleep(10000)

# Ask the threads to stop.
for c in terminate.mitems:
  c.send(true)

joinThreads([tequal, tdist, tdisp])

# Free resources.
randomLock.deinitLock()
for lock in bucketLocks.mitems:
  lock.deinitLock()
for c in terminate.mitems:
  c.close()
