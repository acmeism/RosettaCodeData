(define (A m n)
  (letrec ((A-stream
    (cons-stream
      (ints-from 1) ;; m = 0
      (cons-stream
        (ints-from 2) ;; m = 1
        (cons-stream
          ;; m = 2
          (stream-map (lambda (n)
                        (1+ (* 2 (1+ n))))
                      (ints-from 0))
          (cons-stream
            ;; m = 3
            (stream-map (lambda (n)
                          (- (knuth-up-arrow 2 (- m 2) (+ n 3)) 3))
                        (ints-from 0))
             ;; m = 4...
            (stream-tail A-stream 3)))))))
    (stream-ref (stream-ref A-stream m) n)))

(define (ints-from n)
  (letrec ((ints-rec (cons-stream n (stream-map 1+ ints-rec))))
    ints-rec))

(define (knuth-up-arrow a n b)
  (let loop ((n n) (b b))
    (cond ((= b 0) 1)
          ((= n 1) (expt a b))
          (else    (loop (-1+ n) (loop n (-1+ b)))))))
