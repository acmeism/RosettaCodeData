(defun make-round ()
  (let ((array (make-array 3
                           :element-type 'bit
                           :initial-element 0)))
    (setf (bit array (random 3)) 1)
    array))

(defun show-goat (initial-choice array)
  (loop for i = (random 3)
        when (and (/= initial-choice i)
                  (zerop (bit array i)))
          return i))

(defun won? (array i)
  (= 1 (bit array i)))
