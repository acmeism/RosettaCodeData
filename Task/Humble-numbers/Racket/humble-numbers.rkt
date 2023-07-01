#lang racket

(define (gen-humble-numbers N (kons #f) (k0 (void)))
  (define rv (make-vector N 1))

  (define (loop n 2-idx 3-idx 5-idx 7-idx next-2 next-3 next-5 next-7 k)
    (if (= n N)
        rv
        (let ((mn (min next-2 next-3 next-5 next-7)))
          (vector-set! rv n mn)
          (define (add-1-if-min n x) (if (= mn n) (add1 x) x))
          (define (*vr.i-if-min n m i) (if (= mn n) (* m (vector-ref rv i)) n))
          (let* ((2-idx  (add-1-if-min next-2 2-idx))
                 (next-2 (*vr.i-if-min next-2 2 2-idx))
                 (3-idx  (add-1-if-min next-3 3-idx))
                 (next-3 (*vr.i-if-min next-3 3 3-idx))
                 (5-idx  (add-1-if-min next-5 5-idx))
                 (next-5 (*vr.i-if-min next-5 5 5-idx))
                 (7-idx  (add-1-if-min next-7 7-idx))
                 (next-7 (*vr.i-if-min next-7 7 7-idx))
                 (k (and kons (kons mn k))))
            (loop (add1 n) 2-idx 3-idx 5-idx 7-idx next-2 next-3 next-5 next-7 k)))))
  (loop 1 0 0 0 0 2 3 5 7 (and kons (kons 1 k0))))

(define ((digit-tracker breaker) h last-ten.count)
  (let ((last-ten (car last-ten.count)))
    (if (< h last-ten)
        (cons last-ten (add1 (cdr last-ten.count)))
        (begin
          (printf "~a humble numbers with ~a digits~%" (cdr last-ten.count) (order-of-magnitude last-ten))
          (cons (breaker (* 10 last-ten)) 1)))))

(define (Humble-numbers)
  (displayln (gen-humble-numbers 50))
  (time
   (let/ec break
     (void (gen-humble-numbers
            100000000
            (digit-tracker (λ (o) (if (> (order-of-magnitude o) 100) (break) o)))
            '(10 . 0))))))

(module+ main
  (Humble-numbers))
