(defun fibonacci (n)
  (let (vec i j k)
    (if (< n 2)
        n
      (setq vec (make-vector (+ n 1) 0)
            i 0
            j 1
            k 2)
      (setf (aref vec 1) 1)
      (while (<= k n)
        (setf (aref vec k) (+ (elt vec i) (elt vec j)))
        (setq i (1+ i)
              j (1+ j)
              k (1+ k)))
      (elt vec n))))
