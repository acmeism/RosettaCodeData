(defparameter *points*
  #((0 . 0) (10 . 0) (10 . 10) (0 . 10)
    (2.5 . 2.5) (7.5 . 2.5) (7.5 . 7.5) (2.5 . 7.5)
    (0 . 5) (10 . 5) (3 . 0) (7 . 0)
    (7 . 10) (3 . 10)))

(defun create-polygon (indices &optional (points *points*))
  (loop for (a b) on indices by 'cddr
        collecting (cons (aref points (1- a))
                         (aref points (1- b)))))

(defun square ()
  (create-polygon '(1 2 2 3 3 4 4 1)))

(defun square-hole ()
  (create-polygon '(1 2 2 3 3 4 4 1 5 6 6 7 7 8 8 5)))

(defun strange ()
  (create-polygon '(1 5 5 4 4 8 8 7 7 3 3 2 2 5)))

(defun exagon ()
  (create-polygon '(11 12 12 10 10 13 13 14 14 9 9 11)))

(defparameter *test-points*
  #((5 . 5) (5 . 8) (-10 . 5) (0 . 5)
    (10 . 5) (8 . 5) (10 . 10)))

(defun test-pip ()
  (dolist (shape '(square square-hole strange exagon))
    (print shape)
    (loop with polygon = (funcall shape)
          for test-point across *test-points*
          do (format t "~&~w ~:[outside~;inside ~]."
                     test-point
                     (point-in-polygon test-point polygon)))))
