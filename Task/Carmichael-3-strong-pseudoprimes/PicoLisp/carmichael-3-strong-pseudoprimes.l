(de modulo (X Y)
   (% (+ Y (% X Y)) Y) )

(de prime? (N)
   (let D 0
      (or
         (= N 2)
         (and
            (> N 1)
            (bit? 1 N)
            (for (D 3  T  (+ D 2))
               (T (> D (sqrt N)) T)
               (T (=0 (% N D)) NIL) ) ) ) ) )

(for P1 61
   (when (prime? P1)
      (for (H3 2 (> P1 H3) (inc H3))
         (let G (+ H3 P1)
            (for (D 1 (> G D) (inc D))
               (when
                  (and
                     (=0
                        (% (* G (dec P1)) D) )
                     (=
                        (modulo (* (- P1) P1) H3)
                        (% D H3)) )
                  (let
                     (P2
                        (inc
                           (/ (* (dec P1) G) D) )
                        P3 (inc (/ (* P1 P2) H3)) )
                     (when
                        (and
                           (prime? P2)
                           (prime? P3)
                           (= 1 (modulo (* P2 P3) (dec P1))) )
                        (print (list P1 P2 P3)) ) ) ) ) ) ) ) )
(prinl)

(bye)
