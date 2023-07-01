(defun m (n)
    (if (zerop n)
        0
        (- n (f (m (- n 1))))))

(defun f (n)
    (if (zerop n)
        1
        (- n (m (f (- n 1))))))
