(defun play ((n-cards . 9))
  (find-enough-sets n-cards (quotient n-cards 2)))
