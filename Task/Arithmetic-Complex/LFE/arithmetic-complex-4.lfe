(defun new (r i)
  (make-complex real r img i))

(defun modulus (cmplx)
  (mult cmplx (conj cmplx)))

(defun div (c1 c2)
   (let* ((denom (complex-real (modulus c2)))
          (c3 (mult c1 (conj c2))))
     (new (/ (complex-real c3) denom)
          (/ (complex-img c3) denom)))))
