(load "@lib/simul.l")

(off 'B)
(for L (subsets 2 (range 1 1200))
   (let K (sum '((N) (** N 3)) L)
      (ifn (lup B K)
         (idx 'B (list K 1 (list L)) T)
         (inc (cdr @))
         (push (cddr @) L) ) ) )
(setq R
   (filter
      '((L) (>= (cadr L) 2))
      (idx 'B)) )
(for L (head 25 R)
   (println (car L) (caddr L)) )
(for L (head 7 (nth R 2000))
   (println (car L) (caddr L)) )
