my @queue does FIFO;

say @queue.is-empty;                      # -> Bool::True
say @queue.enqueue: <A B C>;              # -> 3
say @queue.enqueue: Any;                  # -> 1
say @queue.enqueue: 7, 8;                 # -> 2
say @queue.is-empty;                      # -> Bool::False
say @queue.dequeue;                       # -> A
say @queue.elems;                         # -> 5
say @queue.dequeue;                       # -> B
say @queue.is-empty;                      # -> Bool::False
say @queue.enqueue('OHAI!');              # -> 1
say @queue.dequeue until @queue.is-empty; # -> C \n Any() \n 7 \n 8 \n OHAI!
say @queue.is-empty;                      # -> Bool::True
say @queue.dequeue;                       # ->
