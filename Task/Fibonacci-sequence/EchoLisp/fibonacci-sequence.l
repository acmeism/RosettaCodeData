(define (fib n)
    (if (< n 2) n
    (+ (fib (- n 2)) (fib (1- n)))))

(remember 'fib #(0 1))

(for ((i 12)) (write (fib i)))
0 1 1 2 3 5 8 13 21 34 55 89
