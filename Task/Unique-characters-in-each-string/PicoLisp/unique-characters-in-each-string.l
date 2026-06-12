(de acc (V K N)
   (if (assoc K (val V))
      (inc (nth (cadr @) N))
      (push V (list K (list 1 0 0))) ) )
(de un (Lst)
   (let (Len (length Lst)  D)
      (for (I . Lst) (mapcar chop Lst)
         (for L Lst
            (acc 'D L I) ) )
      (mapcar
         car
         (by
            car
            sort
            (filter '((L) (fully =1 (cadr L))) D) ) ) ) )
(println
   (un
      (quote
         "1a3c52debeffd"
         "2b6178c97a938stf"
         "3ycxdb1fgxa2yz" ) ) )
