(defun ulam-spiral (n)
  (loop for a in (spiral n n (* n n)) do
        (format t "~{~d~}~%" a)))

(defun spiral
    (n m b &aux (row (loop for a below n
                           collect (if (primep (- b a))
                                       '* '#\space))))
  (if (= m 1) (list row)
      (cons row (mapcar #'reverse
                        (apply #'mapcar #'list
                               (spiral (1- m) n
                                       (- b n)))))))
(defun primep (n)
  (when (> n 1) (loop for a from 2 to (isqrt n)
                      never (zerop (mod n a)))))
