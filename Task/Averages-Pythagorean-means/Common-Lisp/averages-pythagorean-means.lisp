(defun generic-mean (nums reduce-op final-op)
  (funcall final-op (reduce reduce-op nums)))

(defun a-mean (nums)
  (generic-mean nums #'+ (lambda (x) (/ x (length nums)))))

(defun g-mean (nums)
  (generic-mean nums #'* (lambda (x) (expt x (/ 1 (length nums))))))

(defun h-mean (nums)
  (generic-mean nums
                (lambda (x y) (+ x
                                 (/ 1 y)))
                (lambda (x) (/ (length nums) x))))

(let ((numbers (loop for i from 1 to 10 collect i)))
  (let ((a-mean (a-mean numbers))
        (g-mean (g-mean numbers))
        (h-mean (h-mean numbers)))
    (assert (> a-mean g-mean h-mean))
    (format t "a-mean ~a~%" a-mean)
    (format t "g-mean ~a~%" g-mean)
    (format t "h-mean ~a~%" h-mean)))
