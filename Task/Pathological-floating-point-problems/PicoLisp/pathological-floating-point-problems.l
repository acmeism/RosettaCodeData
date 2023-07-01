(scl 150)
(de task1 (N)
   (cache '(NIL) N
      (cond
         ((= N 1) 2.0)
         ((= N 2) -4.0)
         (T
            (+
               (- 111.0 (*/ 1.0 1130.0 (task1 (- N 1))))
               (*/
                  1.0
                  3000.0
                  (*/
                     (task1 (- N 2))
                     (task1 (- N 1))
                     1.0 ) ) ) ) ) ) )
(for N (list 3 4 5 6 7 8 20 30 50 100)
   (println 'N: N (round (task1 N) 20)) )

# task 2
(setq B (- 2.7182818284590452353602874713526624977572470 1.0))
(for N 25
   (setq B
      (-
         (* N B)
         1.0 ) ) )
(prinl "bank balance after 25 years: "  (round B 20))

# task 3
(de pow (A B)     # fixedpoint
   (*/ 1.0 (** A B) (** 1.0 B)) )
(de task3 (A B)
   (let
      (A2 (pow A 2)
         B2 (pow B 2)
         B4 (pow B 4)
         B6 (pow B 6)
         B8 (pow B 8) )
      (+
         (*/ 333.75 B6 1.0)
         (*/
            A2
            (-
               (*/ 11.0 A2 B2 (** 1.0 2))
               B6
               (* 121 B4)
               2.0 )
            1.0 )
         (*/ 5.5 B8 1.0)
         (*/ 1.0 A (*/ 2.0 B 1.0)) ) ) )
(prinl "Rump's example: " (round (task3 77617.0 33096.0) 20))
