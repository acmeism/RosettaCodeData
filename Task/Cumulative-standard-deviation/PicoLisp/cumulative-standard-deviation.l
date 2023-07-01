(scl 2)

(de stdDev ()
   (curry ((Data)) (N)
      (push 'Data N)
      (let (Len (length Data)  M (*/ (apply + Data) Len))
         (sqrt
            (*/
               (sum
                  '((N) (*/ (- N M) (- N M) 1.0))
                  Data )
               1.0
               Len )
            T ) ) ) )

(let Fun (stdDev)
   (for N (2.0 4.0 4.0 4.0 5.0 5.0 7.0 9.0)
      (prinl (format N *Scl) " -> " (format (Fun N) *Scl)) ) )
