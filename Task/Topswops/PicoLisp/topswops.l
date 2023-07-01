(de fannkuch (N)
   (let (Lst (range 1 N)  L Lst  Max)
      (recur (L)  # Permute
         (if (cdr L)
            (do (length L)
               (recurse (cdr L))
               (rot L) )
            (zero N)  # For each permutation
            (for (P (copy Lst)  (> (car P) 1)  (flip P (car P)))
               (inc 'N) )
            (setq Max (max N Max)) ) )
      Max ) )

(for I 10
   (println I (fannkuch I)) )
