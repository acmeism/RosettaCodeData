(defun bit-complement (bit-vector)
  (loop with result = (make-array (length bit-vector) :element-type 'bit)
        for b across bit-vector
        for i from 0
        do (setf (aref result i) (- 1 b))
        finally (return result)))

(defun next (bit-vector)
  (concatenate 'bit-vector bit-vector (bit-complement bit-vector)))

(defun print-bit-vector (bit-vector)
  (loop for b across bit-vector
        do (princ b)
        finally (terpri)))

(defun thue-morse (max)
  (loop repeat (1+ max)
        for value = #*0 then (next value)
        do (print-bit-vector value)))

(thue-morse 6)
