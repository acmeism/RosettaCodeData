(de rangeextract (Lst)
   (glue ","
      (make
         (while Lst
            (let (N (pop 'Lst)  M N)
               (while (= (inc M) (car Lst))
                  (setq M (pop 'Lst)) )
               (cond
                  ((= N M) (link N))
                  ((= (inc N) M) (link N M))
                  (T (link (list N '- M))) ) ) ) ) ) )
