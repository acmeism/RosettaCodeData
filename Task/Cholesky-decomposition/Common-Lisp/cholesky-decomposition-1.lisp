;; Calculates the Cholesky decomposition matrix L
;; for a positive-definite, symmetric nxn matrix A.
(defun chol (A)
  (let* ((n (car (array-dimensions A)))
         (L (make-array `(,n ,n) :initial-element 0)))

    (do ((k 0 (incf k))) ((> k (- n 1)) nil)
        ;; First, calculate diagonal elements L_kk.
        (setf (aref L k k)
              (sqrt (- (aref A k k)
                       (do* ((j 0 (incf j))
                             (sum (expt (aref L k j) 2)
                                  (incf sum (expt (aref L k j) 2))))
                            ((> j (- k 1)) sum)))))

        ;; Then, all elements below a diagonal element, L_ik, i=k+1..n.
        (do ((i (+ k 1) (incf i)))
            ((> i (- n 1)) nil)

            (setf (aref L i k)
                  (/ (- (aref A i k)
                        (do* ((j 0 (incf j))
                              (sum (* (aref L i j) (aref L k j))
                                   (incf sum (* (aref L i j) (aref L k j)))))
                             ((> j (- k 1)) sum)))
                     (aref L k k)))))

    ;; Return the calculated matrix L.
    L))
