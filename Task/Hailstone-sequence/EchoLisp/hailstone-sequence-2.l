(define H27 (iterator/f hailstone 27))
(take H27 6)
   → (27 82 41 124 62 31)
(length H27)
   → 112
(list-tail (take H27 112) -6)
   → (5 16 8 4 2 1)

(task)
maxlength=     351     for     77031

;; more ...
(lib 'bigint)

(task 200000)
    maxlength=     383     for     156159
(task 300000)
    maxlength=     443     for     230631
(task 400000)
    maxlength=     443     for     230631
(task 500000)
    maxlength=     449     for     410011
(task 600000)
    maxlength=     470     for     511935
(task 700000)
    maxlength=     509     for     626331
(task 800000)
    maxlength=     509     for     626331
(task 900000)
    maxlength=     525     for     837799
(task 1000000)
    maxlength=     525     for     837799
