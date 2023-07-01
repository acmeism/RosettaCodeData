(scl 40)

(de solveQuad (A B C)
   (let SD (sqrt (- (* B B) (* 4 A C)))
      (if (lt0 B)
         (list
            (*/ (- SD B) A 2.0)
            (*/ C 2.0 (*/ A A (- SD B) `(* 1.0 1.0))) )
         (list
            (*/ C 2.0 (*/ A A (- 0 B SD) `(* 1.0 1.0)))
            (*/ (- 0 B SD) A 2.0) ) ) ) )

(mapcar round
   (solveQuad 1.0 -1000000.0 1.0)
   (6 .) )
