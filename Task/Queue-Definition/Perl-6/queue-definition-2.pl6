my @queue does FIFO;

say @queue.is-empty;                         # -> Bool::True
for <A B C> -> $i { say @queue.enqueue: $i } # 1 \n 1 \n 1
say @queue.enqueue: Any;                     # -> 1
say @queue.enqueue: 7, 8;                    # -> 2
say @queue.is-empty;                         # -> Bool::False
say @queue.dequeue;                          # -> A
say @queue.elems;                            # -> 4
say @queue.dequeue;                          # -> B
say @queue.is-empty;                         # -> Bool::False
say @queue.enqueue('OHAI!');                 # -> 1
say @queue.dequeue until @queue.is-empty;    # -> C \n Any() \n [7 8] \n OHAI!
say @queue.is-empty;                         # -> Bool::True
say @queue.dequeue;                          # ->
