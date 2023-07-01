(defun root-mean-square (numbers)
  "Takes a list of numbers, returns their quadratic mean."
  (sqrt
   (/ (apply #'+ (mapcar #'(lambda (x) (* x x)) numbers))
      (length numbers))))

(root-mean-square (loop for i from 1 to 10 collect i))
