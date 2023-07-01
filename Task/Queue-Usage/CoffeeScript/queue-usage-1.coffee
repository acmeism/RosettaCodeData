# We build a Queue on top of an ordinary JS array, which supports push
# and shift.  For simple queues, it might make sense to just use arrays
# directly, but this code shows how to encapsulate the array behind a restricted
# API.  For very large queues, you might want a more specialized data
# structure to implement the queue, in case arr.shift works in O(N) time, which
# is common for array implementations.  On my laptop I start noticing delay
# after about 100,000 elements, using node.js.
Queue = ->
  arr = []
  enqueue: (elem) ->
    arr.push elem
  dequeue: (elem) ->
    throw Error("queue is empty") if arr.length == 0
    arr.shift elem
  is_empty: (elem) ->
    arr.length == 0

# test
do ->
  q = Queue()
  for i in [1..100000]
    q.enqueue i

  console.log q.dequeue() # 1
  while !q.is_empty()
    v = q.dequeue()
  console.log v # 1000

  try
    q.dequeue() # throws Error
  catch e
    console.log "#{e}"
