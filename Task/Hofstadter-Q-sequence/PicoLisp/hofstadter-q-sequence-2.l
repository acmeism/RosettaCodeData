: (mapcar q (range 1 10))
-> (1 1 2 3 3 4 5 5 6 6)

: (q 1000)
-> 502

: (let L (mapcar q (range 1 100000))
   (cnt < (cdr L) L) )
-> 49798
