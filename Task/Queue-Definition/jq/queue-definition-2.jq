fifo | pop  # produces [null,[]]

fifo
 | push(42) # enqueue
 | push(43) # enqueue
 | pop      # dequeue
 | .[0]     # the value
# produces 43

fifo|push(1) as $q1
| fifo|push(2) as $q2
| [($q1|pop|.[0]), ($q2|pop|.[0])]
# produces: [1, 2]
