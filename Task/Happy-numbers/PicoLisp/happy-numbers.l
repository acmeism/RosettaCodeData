(de happy? (N)
   (let Seen NIL
      (loop
         (T (= N 1) T)
         (T (member N Seen))
         (setq N
            (sum '((C) (** (format C) 2))
               (chop (push 'Seen N)) ) ) ) ) )

(let H 0
   (do 8
      (until (happy? (inc 'H)))
      (printsp H) ) )
