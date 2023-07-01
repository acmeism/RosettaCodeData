(de dictionary (N)
   (extract
      '((A B)
         (and
            (= "1" B)
            (mapcar
               '((L) (if (= "1" L) "#" "."))
               A ) ) )
      (mapcar
         '((N) (chop (pad 3 (bin N))))
         (range 7 0) )
      (chop (pad 8 (bin N))) ) )
(de cellular (Lst N)
   (let (Lst (chop Lst)  D (dictionary N))
      (do 10
         (prinl Lst)
         (setq Lst
            (make
               (map
                  '((L)
                     (let Y (head 3 L)
                        (and
                           (cddr Y)
                           (link (if (member Y D) "#" ".")) ) ) )
                  (conc (cons (last Lst)) Lst (cons (car Lst))) ) ) ) ) ) )
(cellular
   ".........#........."
   90 )
