(defun mean (v)
    (if (= (vector-length v) 0)
        nil
        (let ((l (vector->list v)))
            (/ (apply + l) (length l)))))
