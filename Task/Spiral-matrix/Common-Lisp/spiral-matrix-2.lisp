(defun spiral (m n &optional (start 1))
  (let ((row (list (loop for x from 0 to (1- m) collect (+ x start)))))
    (if (= 1 n) row
      ;; first row, plus (n-1) x m spiral rotated 90 degrees
      (append row (map 'list #'reverse
		       (apply #'mapcar #'list
			      (spiral (1- n) m (+ start m))))))))

;; test
(loop for row in (spiral 4 3) do
      (format t "~{~4d~^~}~%" row))
