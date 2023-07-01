: (object 'A '(+A))
-> A
: (object 'B '(+B))
-> B
: (list (send 'do-something> 'A) (send 'do-something> 'B))
-> ("Do something to A" "No method for do-something> on B")
