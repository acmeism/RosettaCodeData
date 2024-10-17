(define (digits n)
  (string->list (number->string n)))

(define (ends-with list tail)
  ;; does list end with tail?
  (starts-with (reverse list)
               (reverse tail)))

(define (starts-with list head)
  (cond ((null? head)
         #t)
        ((null? list)
         #f)
        ((equal? (car list) (car head))
         (starts-with (cdr list) (cdr head)))
        (else
         #f)))

(let loop ((i 1))
  (if (ends-with (digits (* i i)) (digits 269696))
      i
      (loop (+ i 1))))

;; 25264
