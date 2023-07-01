(defun horner (x a)
    (loop :with y = 0
          :for i :from (1- (length a)) :downto 0
          :do (setf y (+ (aref a i) (* y x)))
          :finally (return y)))

(horner 1.414 #(-2 0 1))
