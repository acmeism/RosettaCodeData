(setq *Blocks
   '((B O) (X K) (D Q) (C P) (N A) (G T) (R E)
   (T G) (Q D) (F S) (J W) (H U) (V I) (A N)
   (O B) (E R) (F S) (L Y) (P C) (Z M) ) )
(setq *Words '("" "1" "A" "BARK" "BOOK" "TREAT"
               "Bbb" "COMMON" "SQUAD" "Confuse"
               "abba" "ANBOCPDQERSFTGUVWXLZ") )

(de abc (W B)
   (let Myblocks (copy B)
      (fully
         '((C)
            (when (seek '((Lst) (member C (car Lst))) Myblocks)
               (set @)
               T ) )
      (chop (uppc W)) ) ) )

(de abcR (W B)
   (nond
      ((car W) T)
      ((car B) NIL)
      (NIL
         (setq W (chop W))
         (let? I
            (find
               '((Lst) (member (uppc (car W)) Lst))
               B )
            (abcR (cdr W) (delete I B)) ) ) ) )

(for Word *Words
   (println Word (abc Word *Blocks) (abcR Word *Blocks)) )

(bye)
