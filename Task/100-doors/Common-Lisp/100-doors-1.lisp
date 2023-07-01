(defun visit-door (doors doornum value1 value2)
  "visits a door, swapping the value1 to value2 or vice-versa"
  (let ((d (copy-list doors))
        (n (- doornum 1)))
    (if (eql  (nth n d) value1)
        (setf (nth n d) value2)
      (setf (nth n d) value1))
    d))

(defun visit-every (doors num iter value1 value2)
  "visits every 'num' door in the list"
  (if (> (* iter num) (length doors))
      doors
    (visit-every (visit-door doors (* num iter) value1 value2)
                 num
                 (+ 1 iter)
                 value1
                 value2)))

(defun do-all-visits (doors cnt value1 value2)
  "Visits all doors changing the values accordingly"
  (if (< cnt 1)
      doors
    (do-all-visits (visit-every doors cnt 1 value1 value2)
                   (- cnt 1)
                   value1
                   value2)))

(defun print-doors (doors)
  "Pretty prints the doors list"
  (format T "~{~A ~A ~A ~A ~A ~A ~A ~A ~A ~A~%~}~%" doors))

(defun start (&optional (size 100))
  "Start the program"
  (let* ((open "_")
         (shut "#")
         (doors (make-list size :initial-element shut)))
    (print-doors (do-all-visits doors size open shut))))
