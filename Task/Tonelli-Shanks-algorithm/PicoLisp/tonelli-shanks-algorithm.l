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
(de ts (N P)
   (and
      (=1 (legendre N P))
      (let
         (Q (dec P)
            S 0
            Z 0
            C 0
            R 0
            D 0
            M 0
            B 0
            I 0 )
         (until (bit? 1 Q)
            (setq Q (>> 1 Q))
            (inc 'S) )
         (if (=1 S)
            (list
               (setq @@ (**Mod N (/ (inc P) 4) P))
               (- P @@) )
            (setq Z 2)
            (until (= (legendre Z P) (dec P))
               (inc 'Z) )
            (setq
               C (**Mod Z Q P)
               R (**Mod N (/ (inc Q) 2) P)
               D (**Mod N Q P)
               M S )
            (until (=1 D)
               (zero I)
               (for
                  (Z
                     D
                     (and (<> Z 1) (< I (dec M)))
                     (setq Z (% (* Z Z) P)) )
                  (inc 'I) )
               (setq B C)
               (for
                  (Z
                     (- M I 1)
                     (> Z 0) (dec Z) )
                  (setq B (% (* B B) P)) )
               (setq
                  R (% (* R B) P)
                  C (% (* B B) P)
                  D (% (* D C) P)
                  M I ) )
            (list R (- P R)) ) ) ) )

(println (ts 10 13))
(println (ts 56 101))
(println (ts 1030 10009))
(println (ts 1032 10009))
(println (ts 44402 100049))
(println (ts 665820697 1000000009))
(println (ts 881398088036 1000000000039))
(println (ts 41660815127637347468140745042827704103445750172002 (+ (** 10 50) 577)))
