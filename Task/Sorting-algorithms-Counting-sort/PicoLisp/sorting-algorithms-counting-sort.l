(de countingSort (Lst Min Max)
   (let Count (need (- Max Min -1) 0)
      (for N Lst
         (inc (nth Count (- N Min -1))) )
      (make
         (map
            '((C I)
               (do (car C) (link (car I))) )
            Count
            (range Min Max) ) ) ) )
