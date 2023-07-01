(load "plcommon/pairing-heap.l")   # Pairing heap from RC task "Priority Queue"

(setq *WHEEL-2357*
   (10  2  4  2  4  6  2  6
     4  2  4  6  6  2  6  4
     2  6  4  6  8  4  2  4
     2  4  8  6  4  6  2  4
     6  2  6  6  4  2  4  6
     2  6  4  2  4  2 10  2 .))

(de "prime?" (N Primes)
   (let S (sqrt N)
      (for P Primes
         (T (> P S) T)
         (T (=0 (% N P)) NIL))))

(de "adjust-heap" (N H)
   (while (= (caar H) N)
      (let (
         Wheel (cadar H)
         P     (cddar H)
      )
      (setq H
         (heap-insert
            (cons
               (+ N (* P (car Wheel)))
               (cdr Wheel)
               P)
            (heap-rest H)))))
   H)

(de primes (Run?)
   (if (not Run?)
      (co 'primegen) # stop
      (co 'primegen
         (yield 2)
         (yield 3)
         (yield 5)
         (yield 7)
         (let (
            P     11
            Q     121
            Wp    (cdr *WHEEL-2357*)
            N     P
            Wn    (cdr *WHEEL-2357*)
            H     (heap-insert (cons Q Wp P) NIL)
         )
         (make
            (link P)
            (loop
               (cond
                  ((= N (caar H))
                     (setq H ("adjust-heap" N H))
                     (inc 'N (pop 'Wn)))

                  ((< N Q)
                     (yield N)
                     (inc 'N (pop 'Wn)))

                  (T
                     (loop
                        (inc 'P (pop 'Wp))
                        (T ("prime?" P (made))))
                     (link P)
                     (setq
                        Q  (* P P)
                        H  (heap-insert (cons Q Wp P) H))))))))))
