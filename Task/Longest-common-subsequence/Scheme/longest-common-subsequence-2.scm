(test-group
 "lcs"
 (test '()  (lcs '(a b c) '(A B C)))
 (test '(a) (lcs '(a a a) '(A A a)))
 (test '()  (lcs '() '(a b c)))
 (test '()  (lcs '(a b c) '()))
 (test '(a c) (lcs '(a b c) '(a B c)))
 (test '(b) (lcs '(a b c) '(A b C)))

 (test     '(  b   d e f     g h   j)
      (lcs '(a b   d e f     g h i j)
           '(A b c d e f F a g h   j))))
