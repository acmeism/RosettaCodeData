(seed (in "/dev/urandom" (rd 8)))

(de knuth (Lst)
   (for (N (length Lst) (>= N 2) (dec N))
      (let I (rand 1 N)
         (xchg (nth Lst N) (nth Lst I)) ) ) )

(let L (range 1 15)
   (println 'before L)
   (knuth L)
   (println 'after L) )
