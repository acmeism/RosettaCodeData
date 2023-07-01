(for L '((1 34 3 98 9 76 45 4) (54 546 548 60))
   (prinl
      (sort L
         '((A B)
            (>
               (format (pack A B))
               (format (pack B A)) ) ) ) ) )
