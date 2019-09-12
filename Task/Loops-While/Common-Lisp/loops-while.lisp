(let ((i 1024))
  (loop while (plusp i) do
        (print i)
        (setf i (floor i 2))))

(loop with i = 1024
      while (plusp i) do
      (print i)
      (setf i (floor i 2)))

(defparameter *i* 1024)
(loop while (plusp *i*) do
      (print *i*)
      (setf *i* (floor *i* 2)))
