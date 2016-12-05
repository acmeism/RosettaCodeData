(load "bf.fasl")

;;(setf mma::bigfloat-bin-prec 1000)

(let ((A (mma:bigfloat-convert 1.0d0))
      (N (mma:bigfloat-convert 1.0d0))
      (Z (mma:bigfloat-convert 0.25d0))
      (G (mma:bigfloat-/ (mma:bigfloat-convert 1.0d0)
			 (mma:bigfloat-sqrt (mma:bigfloat-convert 2.0d0)))))
  (loop repeat 18 do
       (let* ((X1  (mma:bigfloat-* (mma:bigfloat-+ A G) (mma:bigfloat-convert 0.5d0)))
	      (X2 (mma:bigfloat-sqrt (mma:bigfloat-* A G)))
	      (V (mma:bigfloat-- X1 A)))
	 (setf Z (mma:bigfloat-- Z  (mma:bigfloat-* (mma:bigfloat-/ (mma:bigfloat-* V V) (mma:bigfloat-convert 1.0d0)) N) ))
	 (setf N (mma:bigfloat-+ N N))
	 (setf A X1)
	 (setf G X2)))
  (mma:bigfloat-/ (mma:bigfloat-* A A) Z))
