: (de first (Fun)
   (Fun) )
-> first

: (de second ()
   "second" )
-> second

: (first second)
-> "second"

: (de add (A B)
   (+ A B) )
-> add

: (add 1 2)
-> 3

: (de call-it (Fun X Y)
   (Fun X Y) )
-> call-it

: (call-it add 1 2)
-> 3

: (mapcar inc (1 2 3 4 5))
-> (2 3 4 5 6)

: (mapcar + (1 2 3) (4 5 6))
-> (5 7 9)

:  (mapcar add (1 2 3) (4 5 6))
-> (5 7 9)
