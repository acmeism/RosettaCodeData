(de leftmost (Lst N H)
   (let L 1
      (while (<= L H)
         (use (X)
            (setq X (/ (+ L H) 2))
         (if (>= (caar (nth Lst X)) N)
               (setq H (dec X))
               (setq L (inc X)) ) ) )
      L ) )

(de patience (Lst)
   (let (L (cons (cons (car Lst)))  C 1  M NIL)
      (for N (cdr Lst)
         (let I (leftmost L N C)
            (and
               (> I C)
               (conc L (cons NIL))
               (inc 'C) )
            (push (nth L I) N) ) )
      (make
         (loop
            (setq M (cons 0 T))
            (for (I . Y) L
               (let? S (car Y)
                  (and
                     (< S (cdr M))
                     (setq M (cons I S)) ) ) )
            (T (=T (cdr M)))
            (link (pop (nth L (car M)))) ) ) ) )

(println
   (patience (4 65 2 -31 0 99 83 782 1)) )

(bye)
