#lang racket/base
(require racket/list racket/format)

(define (index-of1 x l) (for/first ((i (in-naturals 1)) (m (in-list l)) #:when (equal? m x)) i))

(define (sprprm n)
  (define n-1 (- n 1))
  (define sp:n-1 (superperm n-1))
  (let loop ((subs (let loop ((sp sp:n-1) (i (- (length sp:n-1) n-1 -1)) (rv null))
                     (cond
                       [(zero? i) (reverse rv)]
                       [else
                        (define sub (take sp n-1))
                        (loop (cdr sp)
                              (- i 1)
                              (if (check-duplicates sub) rv (cons sub rv)))])))
             (ary null))
    (if (null? subs)
        ary
        (let ((sub (car subs)))
          (define i (if (null? ary) 0 (index-of1 (last ary) sub)))
          (loop (cdr subs) (append ary (drop sub i) (list n) sub))))))

(define superperm
  (let ((hsh (make-hash (list (cons 1 (list 1))))))
    (lambda (n) (hash-ref! hsh n (lambda () (sprprm n))))))


(define (20..20 ary)
  (if (< (length ary) 41) ary (append (take ary 20) (cons '.. (take-right ary 20)))))

(for* ((n (in-range 1 (add1 8))) (ary (in-value (superperm n))))
  (printf "~a: len = ~a : ~a~%" (~a n #:width 3) (~a (length ary) #:width 8) (20..20 ary)))
