(defvar *a* (vector 1 2 3))
(map-into *a* #'1+ *a*)
