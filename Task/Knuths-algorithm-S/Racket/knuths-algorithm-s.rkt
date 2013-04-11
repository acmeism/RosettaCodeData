#lang racket

(define (s-of-n-creator n)
  (let* ([count 0] ; 'i' in the description
         [vec (make-vector n)]) ; store the elts we've seen so far
    (lambda (item)
      (if (< count n)
          ; we're not full, so, kind of boring
          (begin
            (vector-set! vec count item)
            (set! count (+ count 1))
            (vector-copy vec 0 count))
          ; we've already seen n elts; fun starts
          (begin
            (set! count (+ count 1))
            (when (< (random) (/ n count))
              (vector-set! vec (random n) item))
            (vector-copy vec))))))

(define counts (make-hash '((0 . 0) (1 . 0) (2 . 0) (3 . 0) (4 . 0) (5 . 0) (6 . 0) (7 . 0) (8 . 0) (9 . 0))))
(for ([iter (in-range 0 100000)]) ; trials
  (let ([s-of-n (s-of-n-creator 3)]) ; set up the chooser
    (for ([d (in-vector ; iterate over the chosen digits
              (for/last ([digit (in-range 0 10)]) ; loop through the digits
                        (s-of-n digit)))]) ; feed them in
      (hash-update! counts d add1)))) ; update counts

(for ([d (in-range 0 10)])
  (printf "~a ~a~n" d (hash-ref counts d)))
