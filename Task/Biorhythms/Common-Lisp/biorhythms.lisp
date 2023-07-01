;;;; Common Lisp biorhythms

;;; Get the days to J2000
;;; FNday only works between 1901 to 2099 - see Meeus chapter 7

(defun day (y m d)
    (+ (truncate (* -7 (+ y (truncate (+ m 9) 12))) 4)
       (truncate (* 275 m) 9) d -730530 (* 367 y)))

;;; Get the difference in days between two dates

(defun diffday (y1 m1 d1 y2 m2 d2)
    (abs (- (day y2 m2 d2) (day y1 m1 d1))))

;;; Print state of a single cycle

(defun print-cycle (diff len nm)
    (let ((perc (round (* 100 (sin (* 2 pi diff (/ 1 len)))))))
          (format t "~A cycle: ~D% " nm perc)
          (if (< (abs perc) 15)
              (format t "(critical)~%")
              (format t "~%"))))

;;; Print all cycles

(defun print-bio (y1 m1 d1 y2 m2 d2)
    (let ((diff (diffday y1 m1 d1 y2 m2 d2)))
          (format t "Age in days: ~D ~%" diff)
          (print-cycle diff 23 "physical")
          (print-cycle diff 28 "emotional")
          (print-cycle diff 33 "intellectual")))
