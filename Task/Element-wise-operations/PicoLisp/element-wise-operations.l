(de elementWiseMatrix (Fun Mat1 Mat2)
   (mapcar '((L1 L2) (mapcar Fun L1 L2)) Mat1 Mat2) )

(de elementWiseScalar (Fun Mat Scalar)
   (elementWiseMatrix Fun Mat (circ (circ Scalar))) )
