; Simpler solution, with the penalty that none of 'iota, 'strike or 'sieve is tail-recursive :
(define (iota start stop stride)
  (if (> start stop)
      (list)
      (cons start (iota (+ start stride) stop stride))))

(define (strike lst start stride)
  (cond ((null? lst) lst)
        ((= (car lst) start) (strike (cdr lst) (+ start stride) stride))
        ((> (car lst) start) (strike lst (+ start stride) stride))
        (else (cons (car lst) (strike (cdr lst) start stride)))))

(define (primes limit)
  (let ((stop (sqrt limit)))
    (define (sieve lst)
      (let ((p (car lst)))
        (if (> p stop)
            lst
            (cons p (sieve (strike (cdr lst) (* p p) p))))))
    (sieve (iota 2 limit 1))))

(display (primes 100))
(newline)
