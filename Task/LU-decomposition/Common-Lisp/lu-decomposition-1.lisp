;; Creates a nxn identity matrix.
(defun eye (n)
  (let ((I (make-array `(,n ,n) :initial-element 0)))
    (loop for j from 0 to (- n 1) do
          (setf (aref I j j) 1))
    I))

;; Swap two rows l and k of a mxn matrix A, which is a 2D array.
(defun swap-rows (A l k)
  (let* ((n (cadr (array-dimensions A)))
         (row (make-array n :initial-element 0)))
    (loop for j from 0 to (- n 1) do
          (setf (aref row j) (aref A l j))
          (setf (aref A l j) (aref A k j))
          (setf (aref A k j) (aref row j)))))

;; Creates the pivoting matrix for A.
(defun pivotize (A)
  (let* ((n (car (array-dimensions A)))
         (P (eye n)))
    (loop for j from 0 to (- n 1) do
          (let ((max (aref A j j))
                (row j))
            (loop for i from j to (- n 1) do
                  (if (> (aref A i j) max)
                      (setq max (aref A i j)
                            row i)))
            (if (not (= j row))
                (swap-rows P j row))))

  ;; Return P.
  P))

;; Decomposes a square matrix A by PA=LU and returns L, U and P.
(defun lu (A)
  (let* ((n (car (array-dimensions A)))
         (L (make-array `(,n ,n) :initial-element 0))
         (U (make-array `(,n ,n) :initial-element 0))
         (P (pivotize A))
         (A (mmul P A)))

    (loop for j from 0 to (- n 1) do
          (setf (aref L j j) 1)
          (loop for i from 0 to j do
                (setf (aref U i j)
                      (- (aref A i j)
                         (loop for k from 0 to (- i 1)
                               sum (* (aref U k j)
                                      (aref L i k))))))
          (loop for i from j to (- n 1) do
                (setf (aref L i j)
                      (/ (- (aref A i j)
                            (loop for k from 0 to (- j 1)
                                  sum (* (aref U k j)
                                         (aref L i k))))
                         (aref U j j)))))

  ;; Return L, U and P.
  (values L U P)))
