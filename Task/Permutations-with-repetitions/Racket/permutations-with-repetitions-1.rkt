#lang racket
(define (permutations-with-repetitions/proc size items)
  (define items-vector (list->vector items))
  (define num (length items))
  (define (pos->element pos)
    (reverse
     (for/list ([p (in-vector pos)])
      (vector-ref items-vector p))))
  (define (next-pos pos)
    (let ([ret (make-vector size #f)])
      (for/fold ([carry 1]) ((i (in-range size)))
        (let ([tmp (+ (vector-ref pos i) carry)])
          (if (= tmp num)
            (begin
              (vector-set! ret i 0)
              #;carry 1)
            (begin
              (vector-set! ret i tmp)
              #;carry 0))))
      ret))
  (define initial-pos (vector->immutable-vector (make-vector size 0)))
  (define last-pos (vector->immutable-vector (make-vector size (sub1 num))))
  (define (continue-after-pos+val? pos val)
    (not (equal? pos last-pos)))

  (make-do-sequence (lambda ()
                      (values pos->element
                              next-pos
                              initial-pos
                              #f
                              #f
                              continue-after-pos+val?))))

(sequence->list (permutations-with-repetitions/proc 2 '(1 2 3)))
