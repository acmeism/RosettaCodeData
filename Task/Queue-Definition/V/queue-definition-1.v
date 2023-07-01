[fifo_create []].
[fifo_push swap cons].
[fifo_pop [[*rest a] : [*rest] a] view].
[fifo_empty? dup empty?].
