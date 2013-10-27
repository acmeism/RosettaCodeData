(displayln (map ffr (list 1 2 3 4 5 6 7 8 9 10)))
(displayln (map ffs (list 1 2 3 4 5 6 7 8 9 10)))

(displayln "Checking for first 1000 integers:")
(displayln (if (equal? (sort (append (for/list ([i (in-range 1 41)])
                                       (ffr i))
                                     (for/list ([i (in-range 1 961)])
                                       (ffs i)))
                             <)
                       (for/list ([i (in-range 1 1001)])
                         i))
               "Test passed"
               "Test failed"))
