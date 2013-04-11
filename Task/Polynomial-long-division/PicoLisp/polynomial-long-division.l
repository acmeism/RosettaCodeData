(de degree (P)
   (let I NIL
      (for (N . C) P
         (or (=0 C) (setq I N)) )
      (dec I) ) )

(de divPoly (N D)
   (if (lt0 (degree D))
      (quit "Div/0" D)
      (let (Q NIL Diff)
         (while (ge0 (setq Diff (- (degree N) (degree D))))
            (setq Q (need (- -1 Diff) Q 0))
            (let E D
               (do Diff (push 'E 0))
               (let F (/ (get N (inc (degree N))) (get E (inc (degree E))))
                  (set (nth Q (inc Diff)) F)
                  (setq N (mapcar '((N E) (- N (* E F))) N E)) ) ) )
         (list Q N) ) ) )
