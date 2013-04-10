(defun perfect-square-list (n)
    "Generates a list of perfect squares from 0 up to n"
    (loop for i from 1 to (sqrt n) collect (expt i 2)))

(defun open-door (doors num open)
    "Sets door at num to open"
    (setf (nth (- num 1) doors) open)
    doors)

(defun visit-all (doors vlist open)
    "Visits and opens all the doors indicated in vlist"
    (if (null vlist)
        doors
        (visit-all (open-door doors (car vlist) open)
                   (cdr vlist)
                   open)))

(defun start2 (&optional (size 100))
    "Start the program"
    (print-doors (visit-all (make-list size :initial-element "#")
                            (perfect-square-list size) "_")))
