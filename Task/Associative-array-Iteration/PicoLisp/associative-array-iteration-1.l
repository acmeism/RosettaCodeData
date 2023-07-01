(put 'A 'foo 5)
(put 'A 'bar 10)
(put 'A 'baz 15)

: (getl 'A)                            # Get the whole property list
-> ((15 . baz) (10 . bar) (5 . foo))

: (mapcar cdr (getl 'A))               # Get all keys
-> (baz bar foo)

: (mapcar car (getl 'A))               # Get all values
-> (15 10 5)
