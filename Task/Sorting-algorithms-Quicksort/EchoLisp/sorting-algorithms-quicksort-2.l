(shuffle (iota 15))
    → (10 0 14 11 13 9 2 5 4 8 1 7 12 3 6)
(quicksort (shuffle (iota 15)) <)
    → (0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)

;; random list of numbers in [0 .. n[
;; count number of comparisons
(define (qtest (n 10000))
	(set! compare 0)
	(quicksort (shuffle (iota n)) >)
	(writeln 'n n 'compare# compare ))
	
(qtest 1000)
  n     1000       compare#     12764
(qtest 10000)
  n     10000      compare#     277868
(qtest 100000)
  n     100000     compare#     6198601
