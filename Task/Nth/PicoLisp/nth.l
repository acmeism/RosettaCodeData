(de rangeth (A B)
   (mapcar
      '((I)
         (pack I
            (if (member (% I 100) (11 12 13))
               'th
               (case (% I 10)
                  (1 'st)
                  (2 'nd)
                  (3 'rd)
                  (T 'th) ) ) ) )
         (range A B) ) )

(prinl (glue " " (rangeth 0 25)))
(prinl (glue " " (rangeth 250 265)))
(prinl (glue " " (rangeth 1000 1025)))

(bye)
