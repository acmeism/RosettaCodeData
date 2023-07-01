(off *Even)

(de nn (Lst N)
   (seek
      '((L)
         (when (car L) (=0 (dec 'N))) )
      Lst ) )

(de lucky (B)
   (let Lst (range (if *Even 2 1) B 2)
      (for A (cdr Lst)
         (for (L (nn Lst A) L (nn (cdr L) A))
            (set L) ) )
      (filter bool Lst) ) )

(argv . *Argv) # without validations
(when (= "evenLucky" (last *Argv)) (on *Even))
(setq *Lst (lucky 7000))
(let (A (format (car *Argv))  B (format (cadr *Argv)))
   (println
      (if (lt0 B)
         (filter '((N) (<= A N (abs B))) *Lst)
         (head B (nth *Lst A)) ) ) )
