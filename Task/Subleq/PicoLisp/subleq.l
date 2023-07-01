(de mem (N)
   (nth
      (quote
         15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1
         72 101 108 108 111 44 32 119 111 114 108 100 33 10 0 )
      (inc N) ) )

(for (IP (mem 0)  IP)
   (let (A (pop 'IP)  B (pop 'IP)  C (pop 'IP))
      (cond
         ((lt0 A) (set (mem B) (char)))
         ((lt0 B) (prin (char (car (mem A)))))
         ((le0 (dec (mem B) (car (mem A))))
            (setq IP (mem C)) ) ) ) )
