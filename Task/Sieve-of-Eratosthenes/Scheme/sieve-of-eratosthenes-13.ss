 ;;;; all primes' multiples are removed, merged through a tree of unions
 ;;;;  runs in ~ n^1.15 run time in producing n = 100K .. 1M primes
 (define (primes-stream)
   (define (mults p) (from-By (* p p) (* 2 p)))
   (define (odd-primes-From from)              ;; odd primes from (odd) f are
       (s-diff (from-By from 2)                ;; all odds from f without the
               (s-tree-join (s-map mults odd-primes))))  ;; multiples of odd primes
   (define odd-primes
       (s-cons 3 (odd-primes-From 5)))         ;; inner feedback loop
   (s-cons 2 (odd-primes-From 3)))             ;; result stream

 ;;;; join an ordered stream of streams (here, of primes' multiples)
 ;;;; into one ordered stream, via an infinite right-deepening tree
 (define (s-tree-join sts)
   (s-cons (head (head sts))
           (s-union (tail (head sts))
                    (s-tree-join (pairs (tail sts))))))

 (define (pairs sts)                        ;; {a.(b.t)} -> (a+b).{t}
     (s-cons (s-cons (head (head sts))
                     (s-union (tail (head sts))
                              (head (tail sts))))
             (pairs (tail (tail sts)))))
