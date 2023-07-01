;; grouping
(for ((i (in-range 2 40 2))) (write (/ (stern i)(stern (1+ i)))))
→ 1/2 1/3 2/3 1/4 3/5 2/5 3/4 1/5 4/7 3/8 5/7 2/7 5/8 3/7 4/5 1/6 5/9 4/11 7/10

;; computing f(1), f(f(1)), etc.
(define (f x)
    (let [(a (/ (- (floor x) -1 (fract x))))]
    (if (> a 1) (f a) (cons a a))))

(define T (make-stream f 1))
(for((i 19)) (write (stream-iterate T)))

→  1/2 1/3 2/3 1/4 3/5 2/5 3/4 1/5 4/7 3/8 5/7 2/7 5/8 3/7 4/5 1/6 5/9 4/11 7/10
