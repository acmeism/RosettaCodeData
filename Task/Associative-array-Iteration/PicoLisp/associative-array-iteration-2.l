(idx 'A (def "foo" 5) T)
(idx 'A (def "bar" 10) T)
(idx 'A (def "baz" 15) T)

: A                                    # Get the whole tree
-> ("foo" ("bar" NIL "baz"))

:  (idx 'A)                            # Get all keys
-> ("bar" "baz" "foo")

:  (mapcar val (idx 'A))               # Get all values
-> (10 15 5)
