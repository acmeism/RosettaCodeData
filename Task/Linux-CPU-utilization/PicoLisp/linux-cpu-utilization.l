(scl 8)
(let (Idl 0  Ttl 0)
   (loop
      (use (L I S)
         (in "/proc/stat"
            (read)
            (setq L (make (do 10 (link (read))))) )
         (setq I (get L 4)  S (sum prog L))
         (prinl
            (round
               (*/
                  100.0
                  (-
                     1.0
                     (*/
                        1.0
                        (- I (swap 'Idl I))
                        (- S (swap 'Ttl S)) ) )
                  1.0 )
               1 )
            '% )
         (wait 1000) ) ) )
