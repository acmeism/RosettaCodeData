;; Assemble the mxn matrix A from the 2D row vector x.
(defun make-conv-matrix (x m n)
  (let ((lx (cadr (array-dimensions x)))
        (A  (make-array `(,m ,n) :initial-element 0)))

    (loop for j from 0 to (- n 1) do
         (loop for i from 0 to (- m 1) do
              (setf (aref A i j)
                    (cond ((or (< i j) (>= i (+ j lx)))
                           0)
                          ((and (>= i j) (< i (+ j lx)))
                           (aref x 0 (- i j)))))))
    A))

;; Solve the overdetermined system A(f)*h=g by linear least squares.
(defun deconv (g f)
  (let* ((lg (cadr (array-dimensions g)))
         (lf (cadr (array-dimensions f)))
         (lh (+ (- lg lf) 1))
         (A  (make-conv-matrix f lg lh)))

    (lsqr A (mtp g))))
