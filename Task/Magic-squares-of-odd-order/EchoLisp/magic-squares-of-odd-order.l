(lib 'matrix)

;; compute next i,j = f(move,i,j)
(define-syntax-rule (path imove jmove)
(begin (set! i (imove i n)) (set! j (jmove j n))))

;; We define the ordinary and break moves
;; (1 , -1), (0, 1) King's move
(define (inext i n) (modulo (1+ i) n))
(define (jnext j n) (modulo (1- j) n))
(define (ibreak i n) i)
(define (jbreak j n) (modulo (1+ j) n))

(define (make-ms n)
    (define n2+1 (1+ (* n n)))
    (define ms (make-array n n))
    (define i (quotient n 2))
    (define j 0)
    (array-set! ms i j 1)

    (for ((ns (in-range 2  n2+1)))
        (if (zero? (array-ref ms (inext i n ) (jnext j n )))
            (path inext jnext) ;; ordinary move if empty target
            (path ibreak jbreak)) ;; else break move

        (if (zero? (array-ref ms i j))
            (array-set! ms i j ns)
            (error ns "illegal path"))
    )
    (writeln 'order n 'magic-number  (/ ( * n n2+1) 2))
    (array-print ms))
