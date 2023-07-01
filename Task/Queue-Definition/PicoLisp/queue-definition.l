(off Queue)                # Clear Queue
(fifo 'Queue 1)            # Store number '1'
(fifo 'Queue 'abc)         # an internal symbol 'abc'
(fifo 'Queue "abc")        # a transient symbol "abc"
(fifo 'Queue '(a b c))     # and a list (a b c)
Queue                      # Show the queue
