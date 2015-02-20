 ;;;; all primes' multiples are removed, merged through a tree of unions
 ;;;;  runs in ~ n^1.15 run time in producing n = 100K .. 1M primes
 (define (primes-stream)
   (define (mults p) (from-By (* p p) (* 2 p)))
   (define (no-mults-From from)
       (s-diff (from-By from 2)
               (s-tree-join (s-map mults odd-primes))))
   (define odd-primes
       (s-cons 3 (no-mults-From 5)))         ;; inner feedback loop
   (s-cons 2 (no-mults-From 3)))             ;; result stream

 ;;;; join an ordered stream of streams (here, of primes' multiples)
 ;;;; into one ordered stream, via an infinite right-deepening tree
 (define (s-tree-join sts)                               ;; sts -> s
   (define (join-With of-Tail sts)                       ;; sts -> s
     (s-cons (head (head sts))
              (s-union (tail (head sts)) (of-Tail (tail sts)))))
   (define (pairs sts)                                   ;; sts -> sts
     (s-cons (join-With head sts) (pairs (tail (tail sts)))))
   (join-With (lambda (t) (s-tree-join (pairs t))) sts))
