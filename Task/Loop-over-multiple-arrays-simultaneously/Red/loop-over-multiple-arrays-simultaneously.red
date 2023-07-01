>>blk: [["a" "b" "c"] ["A" "B" "C"] [1 2 3]]
== [["a" "b" "c"] ["A" "B" "C"] [1 2 3]]

>> repeat counter 3 [print [blk/1/:counter blk/2/:counter blk/3/:counter]]
a A 1
b B 2
c C 3
