(de sqfun (N)
   (+ N (sqrt N T)) )  # 'sqrt' rounds when called with 'T'

(for I 22
   (println I (sqfun I)) )

(for I 1000000
   (let (N (sqfun I)  R (sqrt N))
      (when (= N (* R R))
         (prinl N " is square") ) ) )
