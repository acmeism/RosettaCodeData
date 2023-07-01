(de glutton (L)
   (let N (pop 'L)
      (maxi length
         (recur (N L)
            (ifn L
               (list (list N))
               (mapcan
                  '((R)
                     (if (> (car R) N)
                        (list (cons N R) R)
                        (list (list N) R) ) )
                  (recurse (car L) (cdr L)) ) ) ) ) ) )

(test (2 4 5)
   (glutton (3 2 6 4 5 1)))

(test (2 6 9 11 15)
   (glutton (8 4 12 2 10 6 14 1 9 5 13 3 11 7 15)))

(test (-31 0 83 782)
   (glutton (4 65 2 -31 0 99 83 782 1)) )
