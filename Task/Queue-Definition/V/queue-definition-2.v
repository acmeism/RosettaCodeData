|fifo_create 3 fifo_push 4 fifo_push 5 fifo_push ??
=[5 4 3]
|fifo_empty? puts
=false
|fifo_pop put fifo_pop put fifo_pop put
=3 4 5
|fifo_empty? puts
 =true
