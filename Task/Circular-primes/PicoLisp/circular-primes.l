(load "plcommon/primality.l")  # see task: "Miller-Rabin Primality Test"

(de candidates (Limit)
   (let Q (0)
      (nth
         (sort
            (make
               (while Q
                  (let A (pop 'Q)
                     (when (< A Limit)
                        (link A)
                        (setq Q
                           (cons
                              (+ (* 10 A) 1)
                              (cons
                                 (+ (* 10 A) 3)
                                 (cons
                                    (+ (* 10 A) 7)
                                    (cons (+ (* 10 A) 9) Q))))))))))
         6)))

(de circular? (P0)
   (and
      (small-prime? P0)
      (fully '((P) (and (>= P P0) (small-prime? P))) (rotations P0))))

(de rotate (L)
   (let ((X . Xs) L)
      (append Xs (list X))))

(de rotations (N)
   (let L (chop N)
      (mapcar
         format
         (make
            (do (dec (length L))
               (link (setq L (rotate L))))))))

(de small-prime? (N)  # For small prime candidates only
   (if (< N 2)
      NIL
      (let W (1 2 2 . (4 2 4 2 4 6 2 6 .))
         (for (D 2  T  (+ D (pop 'W)))
            (T  (> (* D D) N)  T)
            (T  (=0 (% N D))   NIL)))))

(de repunit-primes (N)
   (let (Test 111111  Remaining N  K 6)
      (make
         (until (=0 Remaining)
            (setq Test (inc (* 10 Test)))
            (inc 'K)
            (when (prime? Test)
               (link K)
               (dec 'Remaining))))))

(setq Circular
   (conc
      (2 3 5 7)
      (filter circular? (candidates 1000000))
      (mapcar '((X) (list 'R X)) (repunit-primes 4))))

(prinl "The first few circular primes:")
(println Circular)
(bye)
