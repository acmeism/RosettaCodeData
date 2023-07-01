(de selfRefSequence (Seed)
   (let L (mapcar format (chop Seed))
      (make
         (for (Cache NIL  (not (idx 'Cache L T)))
            (setq L
               (las (flip (sort (copy (link L))))) ) ) ) ) )

(let Res NIL
   (for Seed 1000000
      (let N (length (selfRefSequence Seed))
         (cond
            ((> N (car Res)) (setq Res (list N Seed)))
            ((= N (car Res)) (queue 'Res Seed)) ) ) )
   (println 'Values: (cdr Res))
   (println 'Iterations: (car Res))
   (mapc prinl (selfRefSequence (cadr Res))) )
