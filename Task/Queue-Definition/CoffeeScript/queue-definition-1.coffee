# Implement a fifo as an array of arrays, to
# greatly amortize dequeue costs, at some expense of
# memory overhead and insertion time.  The speedup
# depends on the underlying JS implementation, but
# it's significant on node.js.
Fifo = ->
  max_chunk = 512
  arr = [] # array of arrays
  count = 0

  self =
    enqueue: (elem) ->
      if count == 0 or arr[arr.length-1].length >= max_chunk
        arr.push []
      count += 1
      arr[arr.length-1].push elem
    dequeue: (elem) ->
      throw Error("queue is empty") if count == 0
      val = arr[0].shift()
      count -= 1
      if arr[0].length == 0
        arr.shift()
      val
    is_empty: (elem) ->
      count == 0

# test
do ->
  max = 5000000
  q = Fifo()
  for i in [1..max]
    q.enqueue
      number: i

  console.log q.dequeue()
  while !q.is_empty()
    v = q.dequeue()
  console.log v
