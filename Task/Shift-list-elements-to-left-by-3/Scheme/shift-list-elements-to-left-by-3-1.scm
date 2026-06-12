; Rotate a list by the given number of elements.
; Positive = Rotate left; Negative = Rotate right.

(define list-rotate
  (lambda (lst n)
    (cond
      ((or (not (pair? lst)) (= n 0))
        lst)
      ((< n 0)
        (let ((end (1- (length lst))))
          (list-rotate (append (list (list-ref lst end)) (list-head lst end)) (1+ n))))
      (else
        (list-rotate (cdr (append lst (list (car lst)))) (1- n))))))
