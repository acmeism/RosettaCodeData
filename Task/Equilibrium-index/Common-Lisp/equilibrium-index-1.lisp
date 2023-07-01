(defun dflt-on-nil (v dflt)
  (if v v dflt))

(defun eq-index (v)
  (do*
       ((stack nil)
        (i 0 (+ 1 i))
        (rest v (cdr rest))
        (lsum 0)
        (rsum (apply #'+ (cdr v))))
       ;; Reverse here is not strictly necessary
       ((null rest) (reverse stack))
    (if (eql lsum rsum) (push i stack))
    (setf lsum (+ lsum (car rest)))
    (setf rsum (- rsum (dflt-on-nil (cadr rest) 0)))))
