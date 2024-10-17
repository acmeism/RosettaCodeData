(run-tm-tests
  "Sorting test"
  (make-turing
    '(0 1 2 3)
    '0
    '(1 2)
    '(A B C D E STOP)
    'A
    '(STOP)
    '(A 1 1 R A)
    '(A 2 3 R B)
    '(A 0 0 L E)
    '(B 1 1 R B)
    '(B 2 2 R B)
    '(B 0 0 L C)
    '(C 1 2 L D)
    '(C 2 2 L C)
    '(C 3 2 L E)
    '(D 1 1 L D)
    '(D 2 2 L D)
    '(D 3 1 R A)
    '(E 1 1 L E)
    '(E 0 0 R STOP))
  (list
    (list 0 #t (make-tape '(2 2 2 1 2 2 1 2 1 2 1 2 1 2) 0 1 1))  ; padding determined empirically
  ) 'notm 'supp)

(run-tm-tests
  "Duplicate sequence of 1s"
  (make-turing
    '(0 1)
    '0
    '(1)
    '(s1 s2 s3 s4 s5 H)
    's1
    '(H)
    '(s1 0 0 N H)
    '(s1 1 0 R s2)
    '(s2 0 0 R s3)
    '(s2 1 1 R s2)
    '(s3 0 1 L s4)
    '(s3 1 1 R s3)
    '(s4 0 0 L s5)
    '(s4 1 1 L s4)
    '(s5 0 1 R s1)
    '(s5 1 1 L s5))
  (list
    (list 0 #t (make-tape '(1 1 1) 0 0 4))    ; padding determined empirically
  ) 'notm 'supp)

(run-tm-tests
  "Turing's first example from On Computable Numbers"
  (make-turing
    '(_ 0 1)
    '_
    '(_)
    '(b c e f)
    'b
    '()
    '(b _ 0 R c)
    '(c _ _ R e)
    '(e _ 1 R f)
    '(f _ _ R b))
  (list
    (list 20 #t (make-tape '(_)))
  ) 'notm 'mark)

(run-tm-tests
  "Palindrome checker"
  (make-turing
    '(_ 1 2)
    '_
    '(1 2)
    '(br r1 e1 r2 e2 wl odd even)
    'br
    '(odd even)
  ; branch to look for 1 or 2 at end
    '(br 1 _ R r1)
    '(br 2 _ R r2)
    '(br _ _ N even)
  ; walk right to end for 1
    '(r1 1 1 R r1)
    '(r1 2 2 R r1)
    '(r1 _ _ L e1)
  ; check end symbol for 1
    '(e1 1 _ L wl)
    '(e1 _ _ N odd)
  ; walk right to end for 2
    '(r2 2 2 R r2)
    '(r2 1 1 R r2)
    '(r2 _ _ L e2)
  ; check end symbol for 2
    '(e2 2 _ L wl)
    '(e2 _ _ N odd)
  ; walk left to beginning
    '(wl 1 1 L wl)
    '(wl 2 2 L wl)
    '(wl _ _ R br))
  (list
    (list 0 #t (make-tape '(1 2 1)))
    (list 0 #t (make-tape '(1 2 2)))
    (list 0 #t (make-tape '(1 1)))
    (list 0 #t (make-tape '(2 1)))
    (list 0 #t (make-tape '(1)))
    (list 0 #f (make-tape '(2 1 1 1 2)))
    (list 0 #f (make-tape '(2 1 1 2 2)))
    (list 0 #f (make-tape '(1 1 2 2 1 1)))
    (list 0 #f (make-tape '(1 1 2 2 1 2)))
  ) 'notm 'mark)
