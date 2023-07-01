(define items (tuple 1 2 3 4 5 6 7 8 9))
(print "tuple before: " items)
(print "tuple after: " (shuffle items))

(define items (list 1 2 3 4 5 6 7 8 9))
(print "list before: " items)
(print "list after: " (list-shuffle items))
