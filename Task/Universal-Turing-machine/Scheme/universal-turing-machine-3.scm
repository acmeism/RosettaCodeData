(run-tm-tests
  "Simple incrementer"
  (make-turing
    '(B 1)
    'B
    '(1)
    '(q0 qf)
    'q0
    '(qf)
    '(q0 1 1 R q0)
    '(q0 B 1 N qf))
  (list
    (list 0 #t (make-tape '(1 1 1)))
    (list 0 #t (make-tape '(B)))
  ) 'notm 'mark)

(run-tm-tests
  "Three-state busy beaver"
  (make-turing
    '(0 1)
    '0
    '()
    '(a b c halt)
    'a
    '(halt)
    '(a 0 1 R b)
    '(a 1 1 L c)
    '(b 0 1 L a)
    '(b 1 1 R b)
    '(c 0 1 L b)
    '(c 1 1 N halt))
  (list
    (list 0 #t (make-tape '(0) 0 3 2))    ; padding determined empirically
  ) 'notm 'mark)

(run-tm-tests
  "5-state 2-symbol probable busy beaver"
  (make-turing
    '(0 1)
    '0
    '()
    '(A B C D E H)
    'A
    '(H)
    '(A 0 1 R B)
    '(A 1 1 L C)
    '(B 0 1 R C)
    '(B 1 1 R B)
    '(C 0 1 R D)
    '(C 1 0 L E)
    '(D 0 1 L A)
    '(D 1 1 L D)
    '(E 0 1 N H)
    '(E 1 0 L A))
  (list
    (list 0 #f (make-tape '(0)))
  ) 'notm 'leng)
