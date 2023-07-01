(defun DegToDeg (a) (rem a 360))
(defun GradToGrad (a) (rem a 400))
(defun MilToMil (a) (rem a 6400))
(defun RadToRad (a) (rem a (* 2 pi)))

(defun DegToGrad (a) (GradToGrad (* (/ a 360) 400)))
(defun DegToRad (a) (RadToRad (* (/ a 360) (* 2 pi))))
(defun DegToMil (a) (MilToMil (* (/ a 360) 6400)))

(defun GradToDeg (a) (DegToDeg (* (/ a 400) 360)))
(defun GradToRad (a) (RadToRad (* (/ a 400) (* 2 pi))))
(defun GradToMil (a) (MilToMil (* (/ a 400) 6400)))

(defun MilToDeg (a) (DegToDeg (* (/ a 6400) 360)))
(defun MilToGrad (a) (GradToGrad (* (/ a 6400) 400)))
(defun MilToRad (a) (RadToRad (* (/ a 6400) (* 2 pi))))

(defun RadToDeg (a) (DegToDeg (* (/ a (* 2 pi)) 360)))
(defun RadToGrad (a) (GradToGrad (* (/ a (* 2 pi)) 400)))
(defun RadToMil (a) (MilToMil (* (/ a (* 2 pi)) 6400)))

(defun angles (&rest angles)
    (if (not angles) (setf angles '(-2 -1 0 1 2 6.2831853 16 57.2957795 359 399 6399 1000000)))
    (dolist (a angles)
        (format t "UNIT   ~15@a   ~15@a   ~15@a   ~15@a   ~15@a~%" "VAL*" "DEG" "GRAD" "MIL" "RAD")
        (format t "Deg  | ~15f | ~15f | ~15f | ~15f | ~15f~%" a (DegToDeg a) (DegToGrad a) (DegToMil a) (DegToRad a))
        (format t "Grad | ~15f | ~15f | ~15f | ~15f | ~15f~%" a (GradToDeg a) (GradToGrad a) (GradToMil a) (GradToRad a))
        (format t "Mil  | ~15f | ~15f | ~15f | ~15f | ~15f~%" a (MilToDeg a) (MilToGrad a) (MilToMil a) (MilToRad a))
        (format t "Rad  | ~15f | ~15f | ~15f | ~15f | ~15f~%~%" a (RadToDeg a) (RadToGrad a) (RadToMil a) (RadToRad a))))
