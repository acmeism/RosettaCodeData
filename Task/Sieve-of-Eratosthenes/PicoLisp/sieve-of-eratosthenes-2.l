(setq WHEEL-2357
    (2  4  2  4  6  2  6  4
     2  4  6  6  2  6  4  2
     6  4  6  8  4  2  4  2
     4  8  6  4  6  2  4  6
     2  6  6  4  2  4  6  2
     6  4  2  4  2 10  2 10 .))

(de roll2357wheel (Limit)
    (let W WHEEL-2357
        (make
            (for (N 11  (<= N Limit)  (+ N (pop 'W)))
                (link N)))))

(de sqr (X) (* X X))

(de remove-multiples (L)
    (let (N (car L)  M (* N N)  P L  Q (cdr L))
        (while Q
            (let A (car Q)
                (until (>= M A)
                    (setq M (+ M N)))
                (when (= A M)
                    (con P (cdr Q))))
            (setq  P Q  Q (cdr Q)))))


(de sieve (Limit)
    (let Sieve (roll2357wheel Limit)
        (for (P Sieve  (<= (sqr (car P)) Limit)  (cdr P))
            (remove-multiples P))
        (append (2 3 5 7) Sieve)))
