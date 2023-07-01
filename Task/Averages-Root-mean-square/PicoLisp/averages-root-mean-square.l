(scl 5)

(let Lst (1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0)
   (prinl
      (format
         (sqrt
            (*/
               (sum '((N) (*/ N N 1.0)) Lst)
               1.0
               (length Lst) )
            T )
         *Scl ) ) )
