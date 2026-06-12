(seed (in "/dev/urandom" (rd 8)))

(de sattolo (Lst)
   (for (N (length Lst) (>= N 2) (dec N))
      (let I (rand 1 (dec N))
         (xchg (nth Lst N) (nth Lst I)) ) ) )

(let L (range 1 15)
   (println 'before L)
   (sattolo L)
   (println 'after L) )
