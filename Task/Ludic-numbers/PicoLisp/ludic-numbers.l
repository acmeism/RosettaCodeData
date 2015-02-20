(de drop (Lst)
   (let N (car Lst)
      (make
         (for (I . X) (cdr Lst)
            (unless (=0 (% I N)) (link X)) ) ) ) )

(de comb (M Lst)
   (cond
      ((=0 M) '(NIL))
      ((not Lst))
      (T
         (conc
            (mapcar
               '((Y) (cons (car Lst) Y))
               (comb (dec M) (cdr Lst)) )
            (comb M (cdr Lst)) ) ) ) )

(de ludic (N)
   (let Ludic (range 1 100000)
      (make
         (link (pop 'Ludic))
         (do (dec N)
            (link (car Ludic))
            (setq Ludic (drop Ludic)) ) ) ) )

(let L (ludic 2005)
   (println (head 25 L))
   (println (cnt '((X) (< X 1000)) L))
   (println (tail 6 L))
   (println
      (filter
         '((Lst)
            (and
              (= (+ 2 (car Lst)) (cadr Lst))
              (= (+ 6 (car Lst)) (caddr Lst)) ) )
         (comb
            3
            (filter '((X) (< X 250)) L) ) ) ) )

(bye)
