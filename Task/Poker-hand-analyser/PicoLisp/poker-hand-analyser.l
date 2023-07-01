(setq *Rank
   '(("2" . 0) ("3" . 1) ("4" . 2)
      ("5" . 3) ("6" . 4) ("7" . 5)
      ("8" . 6) ("9" . 7) ("t" . 8)
      ("j" . 9) ("q" . 10) ("k" . 11)
      ("a" . 12) ) )
(de poker (Str)
   (let (S NIL  R NIL  Seq NIL)
      (for (L (chop Str) (cdr L) (cdddr L))
         (accu 'R (cdr (assoc (car L) *Rank)) 1)
         (accu 'S (cadr L) 1) )
      (setq Seq
         (make
            (for (L (by car sort R) (cdr L) (cdr L))
               (link (- (caar L) (caadr L))) ) ) )
      (cond
         ((and
            (= 5 (cdar S))
            (or
               (= (-1 -1 -1 -1) Seq)
               (= (-1 -1 -1 -9) Seq) ) )
            'straight-flush )
         ((rassoc 4 R) 'four-of-a-kind)
         ((and (rassoc 2 R) (rassoc 3 R)) 'full-house)
         ((= 5 (cdar S)) 'flush)
         ((or
            (= (-1 -1 -1 -1) Seq)
            (= (-1 -1 -1 -9) Seq) )
            'straight )
         ((rassoc 3 R) 'three-of-a-kind)
         ((=
            2
            (cnt '((L) (= 2 (cdr L))) R) )
            'two-pair )
         ((rassoc 2 R) 'pair)
         (T 'high-card) ) ) )
