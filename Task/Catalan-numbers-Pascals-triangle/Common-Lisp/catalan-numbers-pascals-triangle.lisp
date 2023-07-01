(defun catalan (n)
  "Return the n-th Catalan number"
  (if (<= n 1)  1
    (let ((result 2))
      (dotimes (k (- n 2) result)
        (setq result (* result (/ (+ n k 2) (+ k 2)))) ))))


(dotimes (n 15)
  (print (catalan (1+ n))) )
