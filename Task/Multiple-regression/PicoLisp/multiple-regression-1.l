(scl 20)

# Matrix transposition
(de matTrans (Mat)
   (apply mapcar Mat list) )

# Matrix multiplication
(de matMul (Mat1 Mat2)
   (mapcar
      '((Row)
         (apply mapcar Mat2
            '(@ (sum */ Row (rest) (1.0 .))) ) )
      Mat1 ) )

# Matrix identity
(de matIdent (N)
   (let L (need N (1.0) 0)
      (mapcar '(() (copy (rot L))) L) ) )

# Reduced row echelon form
(de reducedRowEchelonForm (Mat)
   (let (Lead 1  Cols (length (car Mat)))
      (for (X Mat X (cdr X))
         (NIL
            (loop
               (T (seek '((R) (n0 (get R 1 Lead))) X)
                  @ )
               (T (> (inc 'Lead) Cols)) ) )
         (xchg @ X)
         (let D (get X 1 Lead)
            (map
               '((R) (set R (*/ (car R) 1.0 D)))
               (car X) ) )
         (for Y Mat
            (unless (== Y (car X))
               (let N (- (get Y Lead))
                  (map
                     '((Dst Src)
                        (inc Dst (*/ N (car Src) 1.0)) )
                     Y
                     (car X) ) ) ) )
         (T (> (inc 'Lead) Cols)) ) )
   Mat )
