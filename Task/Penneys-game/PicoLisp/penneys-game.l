(seed (in "/dev/urandom" (rd 8)))

(setq *S (list 0 0))

(de toss (N)
   (make
      (do N
         (link (if (rand T) "T" "H")) ) ) )

(de comp (A Lst)
   (or
      (for ((I . L) Lst (cddr L) (cdr L))
         (T (fully = A L) I) )
      T ) )

(de score NIL
   (prinl)
   (prinl "Total score:")
   (prinl "^Iuser: " (car *S))
   (prinl "^Icomp: " (cadr *S)) )

(de play NIL
   (let (C (toss 3)  Lst (toss (rand 5 12))  U)
      (prinl)
      (prin "Select toss: ")
      (setq U (in NIL (skip) (line)))
      (prinl "Comp toss: " C)
      (prinl "Toss: " Lst)
      (setq @ (comp U Lst)  @@ (comp C Lst) )
      (cond
         ((< @ @@) (prinl "User win.") (inc *S))
         ((> @ @@) (prinl "Comp win.") (inc (cdr *S)))
         (T (prinl "Draw, lets play again.")) )
      (score) ) )

(de go NIL
   (loop
      (play)
      (T
         (prog
            (prinl)
            (prin "Want play again? Y/N: ")
            (= "N" (uppc (in NIL (char)))) ) ) ) )

(go)
