(for N 5000
   (and
      (=
         N
         (sum
            '((N) (** N N))
            (mapcar format (chop N)) ) )
      (println N) ) )
