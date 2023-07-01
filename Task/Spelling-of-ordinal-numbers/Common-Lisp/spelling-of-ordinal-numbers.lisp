(defun ordinal-number (n)
  (format nil "~:R" n))

#|
CL-USER> (loop for i in '(1 2 3 4 5 11 65 100 101 272 23456 8007006005004003)
               do (format t "~a: ~a~%" i (ordinal-number i)))
1: first
2: second
3: third
4: fourth
5: fifth
11: eleventh
65: sixty-fifth
100: one hundredth
101: one hundred first
272: two hundred seventy-second
23456: twenty-three thousand four hundred fifty-sixth
8007006005004003: eight quadrillion seven trillion six billion five million four thousand third
NIL
|#
