# from @lib/rsa.l
(de **Mod (X Y N)
   (let M 1
      (loop
         (when (bit? 1 Y)
            (setq M (% (* M X) N)) )
         (T (=0 (setq Y (>> 1 Y)))
            M )
         (setq X (% (* X X) N)) ) ) )
(de legendre (N P)
   (**Mod N (/ (dec P) 2) P) )
(de mul ("A" B P W2)
   (let (A (copy "A")  B (copy B))
      (set
         "A"
         (%
            (+
               (* (car A) (car B))
               (* (cadr A) (cadr B) W2) )
            P )
         (cdr "A")
         (%
            (+
               (* (car A) (cadr B))
               (* (car B) (cadr A)) )
            P ) ) ) )
(de ci (N P)
   (and
      (=1 (legendre N P))
      (let
         (A 0
            W2 0
            R NIL
            S NIL )
         (loop
            (setq W2
               (% (- (+ (* A A) P) N) P) )
            (T (= (dec P) (legendre W2 P)))
            (inc 'A) )
         (setq R (list 1 0)  S (list A 1))
         (for
            (N
               (% (>> 1 (inc P)) P)
               (> N 0)
               (>> 1 N) )
            (and (bit? 1 N) (mul R S P W2))
            (mul S S P W2) )
         (=0 (cadr R))
         (=
            N
            (% (* (car R) (car R)) P) )
         (list (car R) (- P (car R))) ) ) )

(println (ci 10 13))
(println (ci 56 101))
(println (ci 8218 10007))
(println (ci 8219 10007))
(println (ci 331575 1000003))
(println (ci 665165880 1000000007))
(println (ci 881398088036 1000000000039))
(println (ci 34035243914635549601583369544560650254325084643201 (+ (** 10 50) 151)))
