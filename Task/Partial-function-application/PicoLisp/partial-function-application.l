(def 'fs mapcar)
(de f1 (N) (* 2 N))
(de f2 (N) (* N N))

(de partial (F1 F2)
   (curry (F1 F2) @
      (pass F1 F2) ) )

(def 'fsf1 (partial fs f1))
(def 'fsf2 (partial fs f2))

(for S '((0 1 2 3) (2 4 6 8))
   (println (fsf1 S))
   (println (fsf2 S)) )
