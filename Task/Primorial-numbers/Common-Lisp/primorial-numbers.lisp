(defun primorial-number-length (n w)
  (values (primorial-number n) (primorial-length w)))

(defun primorial-number (n)
  (loop for a below n collect (primorial a)))

(defun primorial-length (w)
  (loop for a in w collect (length (write-to-string (primorial a)))))

(defun primorial (n &optional (m 1) (k -1) (z 1) &aux (f (primep m)))
  (if (= k n) z (primorial n (1+ m) (+ k (if f 1 0)) (if f (* m z) z))))

(defun primep (n)
  (loop for a from 2 to (isqrt n) never (zerop (mod n a))))
