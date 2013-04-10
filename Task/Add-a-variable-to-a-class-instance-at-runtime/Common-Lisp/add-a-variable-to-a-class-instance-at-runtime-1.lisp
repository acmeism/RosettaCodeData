(defun augment-instance-with-slots (instance slots)
  (change-class instance
                (make-instance 'standard-class
                  :direct-superclasses (list (class-of instance))
                  :direct-slots slots)))
