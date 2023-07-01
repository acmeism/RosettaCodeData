(load "@lib/simul.l")

(de ceil (A)
   (/ (+ A 1) 2) )

(de prime? (N)
   (or
      (= N 2)
      (and
         (> N 1)
         (bit? 1 N)
         (let S (sqrt N)
            (for (D 3  T  (+ D 2))
               (T (> D S) T)
               (T (=0 (% N D)) NIL) ) ) ) ) )

(de ulam (N)
   (let
      (G (grid N N)
         D '(north west south east .)
         M (ceil N) )
      (setq This
         (intern
            (pack
               (char
                  (+ 96 (if (bit? 1 N) M (inc M))) )
               M ) ) )
      (=: V '_)
      (with ((car D) This)
         (for (X 2 (>= (* N N) X) (inc X))
            (=: V (if (prime? X) '. '_))
            (setq This
               (or
                  (with ((cadr D) This)
                     (unless (: V) (pop 'D) This) )
                  ((pop D) This) ) ) ) )
      G ) )

(mapc
   '((L)
      (for This L
         (prin (align 3 (: V))) )
      (prinl) )
   (ulam 9) )

(bye)
