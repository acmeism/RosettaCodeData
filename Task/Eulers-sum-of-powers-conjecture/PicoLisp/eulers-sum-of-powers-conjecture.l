(off P)
(off S)

(for I 250
   (idx
      'P
      (list (setq @@ (** I 5)) I)
      T )
   (for (J I (>= 250 J) (inc J))
      (idx
         'S
         (list (+ @@ (** J 5)) (list I J))
         T ) ) )
(println
   (catch 'found
      (for A (idx 'P)
         (for B (idx 'S)
            (T (<= (car A) (car B)))
            (and
               (lup S (- (car A) (car B)))
               (throw 'found
                  (conc
                     (cadr (lup S (car B)))
                     (cadr (lup S (- (car A) (car B))))
                     (cdr (lup P (car A))) ) ) ) ) ) ) )
