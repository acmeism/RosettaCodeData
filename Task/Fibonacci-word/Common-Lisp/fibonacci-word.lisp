(defun make-fibwords (array)
  (loop for i from 0 below 37
        for j = "0" then (concatenate 'string j k)
        and k = "1" then j
     do (setf (aref array i) k))
  array)

(defvar *fib* (make-fibwords (make-array 37)))

(defun entropy (string)
  (let ((table (make-hash-table :test 'eql))
        (entropy 0d0)
        (n (length string)))
    (mapc (lambda (c)
            (setf (gethash c table) (+ (gethash c table 0) 1)))
          (coerce string 'list))
    (maphash (lambda (k v)
               (declare (ignore k))
               (decf entropy (* (/ v n) (log (/ v n) 2))))
             table)
    entropy))

(defun string-or-dots (string)
  (if (> (length string) 40)
      "..."
      string))

(format t "~2A ~10A ~17A ~A~%" "N" "Length" "Entropy" "Fibword")
(loop for i below 37
      for n = (aref *fib* i) do
     (format t "~2D ~10D ~17,15F ~A~%"
             (1+ i) (length n) (entropy n) (string-or-dots n)))
