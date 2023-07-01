(de esthetic (N Base)
   (let Lst
      (make
         (loop
            (yoke (% N Base))
            (T (=0 (setq N (/ N Base)))) ) )
      (and
         (fully
            =1
            (make
               (for (L Lst (cdr L) (cdr L))
                  (link (abs (- (car L) (cadr L)))) ) ) )
         (pack
            (mapcar
               '((C)
                  (and (> C 9) (inc 'C 39))
                  (char (+ C 48)) )
               Lst ) ) ) ) )
(de genCount (Num Base)
   (let (C 0  N 0)
      (tail
         (inc (* 2 Base))
         (make
            (while (>= Num C)
               (when (esthetic N Base) (link @) (inc 'C))
               (inc 'N) ) ) ) ) )
(de genRange (A B Base)
   (make
      (while (>= B A)
         (when (esthetic A Base) (link @))
         (inc 'A) ) ) )
(for (N 2 (>= 16 N) (inc N))
   (prin "Base " N ": ")
   (mapc '((L) (prin L " ")) (genCount (* 6 N) N))
   (prinl) )
(prinl)
(prinl "Base 10: 61 esthetic numbers between 1000 and 9999:")
(let L (genRange 1000 9999 10)
   (while (cut 16 'L)
      (mapc '((L) (prin L " ")) @)
      (prinl) ) )
(prinl)
(prinl "Base 10: 126 esthetic numbers between 100000000 and 130000000:")
(let L (genRange 100000000 130000000 10)
   (while (cut 9 'L)
      (mapc '((L) (prin L " ")) @)
      (prinl) ) )
