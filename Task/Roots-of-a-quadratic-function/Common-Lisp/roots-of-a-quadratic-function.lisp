(defun quadratic (a b c)
  (list
   (/ (+ (- b) (sqrt (- (expt b 2) (* 4 a c)))) (* 2 a))
   (/ (- (- b) (sqrt (- (expt b 2) (* 4 a c)))) (* 2 a))))
