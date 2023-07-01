(load "@lib/frac.l")

(de fact (N)
   (cache '(NIL) N
      (if (=0 N) 1 (apply * (range 1 N))) ) )

(de binomial (N K)
   (frac
      (/
         (fact N)
         (* (fact (- N K)) (fact K)) )
      1 ) )

(de A (N M)
   (let Sum (0 . 1)
      (for X M
         (setq Sum
            (f+
               Sum
               (f*
                  (binomial (+ N 3) (- N (* X 6)))
                  (berno (- N (* X 6)) ) ) ) ) )
      Sum ) )

(de berno (N)
   (cache '(NIL) N
      (cond
         ((=0 N) (1 . 1))
         ((= 1 N) (-1 . 2))
         ((bit? 1 N) (0 . 1))
         (T
            (case (% N 6)
               (0
                  (f/
                     (f-
                        (frac (+ N 3) 3)
                        (A N (/ N 6)) )
                     (binomial (+ N 3) N) ) )
               (2
                  (f/
                     (f-
                        (frac (+ N 3) 3)
                        (A N (/ (- N 2) 6)) )
                     (binomial (+ N 3) N) ) )
               (4
                  (f/
                     (f-
                        (f* (-1 . 1) (frac (+ N 3) 6))
                        (A N (/ (- N 4) 6)) )
                     (binomial (+ N 3) N) ) ) ) ) ) ) )

(de berno-brute (N)
   (cache '(NIL) N
      (let Sum (0 . 1)
         (cond
            ((=0 N) (1 . 1))
            ((= 1 N) (-1 . 2))
            ((bit? 1 N) (0 . 1))
            (T
               (for (X 0 (> N X) (inc X))
                  (setq Sum
                     (f+
                        Sum
                        (f* (binomial (inc N) X) (berno-brute X)) ) ) )
               (f/ (f* (-1 . 1) Sum) (binomial (inc N) N)) ) ) ) ) )

(for (N 0 (> 62 N) (inc N))
   (if (or (= N 1) (not (bit? 1 N)))
      (tab (2 4 -60) N " => " (sym (berno N))) ) )

(for (N 0 (> 400 N) (inc N))
   (test (berno N) (berno-brute N)) )

(bye)
