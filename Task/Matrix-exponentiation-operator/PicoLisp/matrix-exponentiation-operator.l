(de matIdent (N)
   (let L (need N (1) 0)
      (mapcar '(() (copy (rot L))) L) ) )

(de matExp (Mat N)
   (let M (matIdent (length Mat))
      (do N
         (setq M (matMul M Mat)) )
      M ) )

(matExp '((3 2) (2 1)) 3)
