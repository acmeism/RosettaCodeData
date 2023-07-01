(put 'A 'foo 5)
(put 'A 'bar 10)
(put 'A 'baz 15)
(put 'A 'foo 20)

: (get 'A 'bar)
-> 10

: (get 'A 'foo)
-> 20

: (show 'A)
A NIL
   foo 20
   bar 10
   baz 15
