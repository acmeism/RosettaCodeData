(defun integer-root (x n)
  (declare (type (integer 0 *) x)  ; x non-negative integer
           (type (integer 1 *) n)) ; n positive integer
  (when (zerop x) (return 0))
  (flet ((next (x_k)
           (floor (+ (* x_k (1- n)) (floor x (expt x_k (1- n)))) n)))
    ;; 2^(lg (x^(1/n))) = 2^(lg(x)/n)
    ;; a good approximation to start with is thus 2^floor(lg(x)/n) or 1 << floor(lg(x)/n)
    (do* ((x_i (ash 1 (floor (log x 2) n)))
          (x_i+1 (next x_i))
          (x_i+2 (next x_i+1)))
         ((or (= x_i x_i+1) (= x_i x_i+2)) (min x_i+1 x_i+2))
      (setf x_i x_i+1
            x_i+1 x_i+2
            x_i+2 (next x_i+2)))))

(format t "~a~%" (integer-root (* 2 (expt 100 2000)) 2))
