(define (combs-with-rep k lst)
  (cond ((= k 0) '(()))
        ((null? lst) '())
        (else
         (append
          (map
           (lambda (x)
             (cons (car lst) x))
           (combs-with-rep (- k 1) lst))
          (combs-with-rep k (cdr lst))))))

(display (combs-with-rep 2 (list "iced" "jam" "plain"))) (newline)
(display (length (combs-with-rep 3 '(1 2 3 4 5 6 7 8 9 10)))) (newline)
