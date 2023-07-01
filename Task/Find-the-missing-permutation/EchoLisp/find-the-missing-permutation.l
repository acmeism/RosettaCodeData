;; use the obvious methos
(lib 'list) ; for (permutations) function

;; input
(define perms '
(ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB))

;; generate all permutations
(define all-perms (map list->string (permutations '(A B C D))))
   → all-perms

;; {set} substraction
(set-substract (make-set all-perms) (make-set perms))
  → { DBAC }
