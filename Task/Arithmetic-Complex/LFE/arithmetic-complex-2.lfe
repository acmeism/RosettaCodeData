(defun add
  (((match-complex real r1 img i1)
    (match-complex real r2 img i2))
   (new (+ r1 r2) (+ i1 i2))))

(defun mult
  (((match-complex real r1 img i1)
    (match-complex real r2 img i2))
   (new (- (* r1 r2) (* i1 i2))
              (+ (* r1 i2) (* r2 i1)))))

(defun neg
  (((match-complex real r img i))
   (new (* -1 r) (* -1 i))))

(defun inv (cmplx)
  (div (conj cmplx) (modulus cmplx)))
