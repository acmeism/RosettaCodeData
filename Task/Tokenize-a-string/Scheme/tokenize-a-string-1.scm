(use-modules (ice-9 regex))
(define s "Hello,How,Are,You,Today")
(define words (map match:substring (list-matches "[^,]+" s)))

(do ((n 0 (+ n 1))) ((= n (length words)))
        (display (list-ref words n))
        (if (< n (- (length words) 1))
                (display ".")))
