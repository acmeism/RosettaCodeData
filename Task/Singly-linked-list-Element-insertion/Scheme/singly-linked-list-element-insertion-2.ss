(define (insert-after! a b lst)
  (let ((pos (member a lst)))
    (if pos
        (set-cdr! pos (cons b (cdr pos))))))
