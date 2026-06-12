;; 0 <= i < N , A <= s <  B , -A = abs(A)
;; mapping two dims Q(i,s) to one-dim Q(qidx(i,s)) :

(define-syntax-rule (qidx i s) (+ i (* (+ s -A) N)))

;; filling the Q array with true/false values
;; Q(i, s) := Q(i − 1, s) or (xi == s) or Q(i − 1, s − xi),  for A ≤ s < B.

(define (fillQ  xs (ds))
    (define N (length xs))
    (define A (apply + (filter negative? xs)))
    (define B (1+ (apply + (filter positive? xs))))
    (define -A (abs A))
    (define Q (make-vector (* N (- B A))))
    (set! xs (list->vector xs))

    (printf "Q[%d] allocated." (vector-length Q))
    (for ((s (in-range A B)))
            (vector-set! Q (qidx 0 s ) (= [xs 0] s)))

    (for*   ([i (in-range 1 N)]
             [s (in-range A B)])

        (set! ds (- s [xs i]))
        (vector-set! Q (qidx i s)
            (or
                [Q (qidx (1- i) s)]
                (= [xs i] s)
                (and (>= ds A) (< ds B) [Q (qidx (1- i) ds )])))

        ;; stop on first zero-sum found
         #:break (and (zero? s) [Q (qidx i s)]) => (solQ Q xs i s -A N)
        ))

;; backtracking to get the list of i's such as sum([xs i]) = 0
;; start from q[i,0] === true

(define  (solQ Q xs i s -A N  (sol null))
    (cond
        (( = s [xs i]) (cons  i  sol))
        ([Q (qidx (1- i ) s)] (solQ Q xs (1- i) s -A N sol))
        (else  (solQ Q xs (1- i) (- s [xs i]) -A N (cons i sol)))))

(define (task input)
    (map  (lambda(i)  (first (list-ref input i))) (fillQ (map rest input))))

