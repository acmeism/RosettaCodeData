(de hofcon (N)
   (cache '(NIL) (pack (char (hash N)) N)
      (if (>= 2 N)
         1
         (+
            (hofcon (hofcon (dec N)))
            (hofcon (- N (hofcon (dec N)))) ) ) ) )

(scl 20)

(de sequence (M)
   (let (Lim 4  Max 0  4k$ 0)
      (for (N 3 (>= M N) (inc N))
         (let V (*/ (hofcon N) 1.0 N)
            (setq Max (max Max V))
            (when (>= V 0.55)
               (setq 4k$ N) )
            (when (= N Lim)
               (prinl
                  "Maximum between " (/ Lim 2)
                  " and " Lim
                  " was " (format Max `*Scl) )
               (inc 'Lim Lim)
               (zero Max) ) ) )
      (prinl
         "Win with " 4k$
         " (the task requests 'n > p' now)" ) ) )

(sequence (** 2 20))
