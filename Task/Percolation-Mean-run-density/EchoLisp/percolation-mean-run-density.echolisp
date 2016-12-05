;; count 1-runs - The vector is not stored
(define (runs p n)
(define ct 0)
(define run-1 #t)
    (for ([i n])
        (if (< (random) p)
        (set! run-1 #t) ;; 0 case
        (begin ;; 1 case
            (when run-1 (set! ct (1+ ct)))
            (set! run-1 #f))))
    (// ct n))

;; mean of t counts
(define (truns p (n 1000 )  (t 1000))
    (// (for/sum ([i t]) (runs p n)) t))

(define (task)
    (for ([p (in-range 0.1 1.0 0.2)])
    (writeln)
    (writeln '🔸 'p p 'Kp (* p (- 1 p)))
        (for ([n '(10 100 1000)])
        (printf "\t-- n %5d   →  %d" n (truns p n)))))
