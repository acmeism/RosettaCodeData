(defun add-suffix (n)
  (format nil "~d'~:[~[th~;st~;nd~;rd~:;th~]~;th~]" n (< (mod (- n 10) 100) 10) (mod n 10)))
