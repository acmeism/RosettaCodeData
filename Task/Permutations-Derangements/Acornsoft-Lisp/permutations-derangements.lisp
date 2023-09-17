(defun subfact (n)
  (cond
    ((eq n 0) 1)
    ((eq n 1) 0)
    (t (times (sub1 n)
          (plus (subfact (sub1 n))
                (subfact (sub1 (sub1 n))))))))

(defun count-derangements (n (count . 0))
  (visit-derangements (range 1 n)
    '(lambda (d) (setq count (add1 count))))
  count)

(defun visit-derangements (original-items d-visitor)
  (visit-permutations original-items
    '(lambda (p)
       (cond ((derangement-p original-items p)
              (d-visitor p))))))

(defun derangement-p (original d (fail . nil))
  (map '(lambda (a b) (cond ((eq a b) (setq fail t))))
       original
       d)
  (not fail))

(defun visit-permutations (items p-visitor)
  (visit-permutations-1 items '()))

(defun visit-permutations-1 (items perm)
  (cond
    ((null items) (p-visitor (reverse perm)))
    (t
     (map '(lambda (i)
              (visit-permutations-1
                 (without i items)
                 (cons i perm)))
          items))))

'(  Utilities  )

(defun without (i items)
  (cond ((null items) '())
        ((eq (car items) i) (cdr items))
        (t (cons (car items) (without i (cdr items))))))

(defun reverse (list (result . ()))
  (map '(lambda (e) (setq result (cons e result)))
       list)
  result)

(defun range (from to)
  (cond ((greaterp from to) '())
        (t (cons from (range (add1 from) to)))))

'(  Examples  )

(defun examples ()
  (show-derangements '(1 2 3 4))
  (printc)
  (map '(lambda (i)
           (printc i
              '!  (count-derangements i)
              '!  (subfact i)))
       (range 0 8)))

(defun show-derangements (items)
  (printc 'Derangements! of!  items)
  (visit-derangements items print))
