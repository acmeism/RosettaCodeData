(defun rad_to_deg (rad)(* 180.0 (/ rad PI)))
(defun deg_to_rad (deg)(* PI (/ deg 180.0)))

(defun asin (x)
  (cond
    ((and(> x -1.0)(< x 1.0)) (atan (/ x (sqrt (- 1.0 (* x x))))))
    ((= x -1.0) (* -1.0 (/ pi 2)))
    ((= x 1) (/ pi 2))
  )
)

(defun acos (x)
  (cond
    ((and(>= x -1.0)(<= x 1.0)) (-(* pi 0.5) (asin x)))
  )
)

(list
(list "cos PI/6" (cos (/ pi 6)) "cos 30 deg" (cos (deg_to_rad 30)))
(list "sin PI/4" (sin (/ pi 4)) "sin 45 deg" (sin (deg_to_rad 45)))
(list "tan PI/3" (tan (/ pi 3))"tan 60 deg" (tan (deg_to_rad 60)))
(list "asin 1 rad" (asin 1.0) "asin 1 rad (deg)" (rad_to_deg (asin 1.0)))
(list "acos 1/2 rad" (acos (/ 1 2.0)) "acos 1/2 rad (deg)" (rad_to_deg (acos (/ 1 2.0))))
(list "atan pi/12" (atan (/ pi 12)) "atan 15 deg" (rad_to_deg(atan(deg_to_rad 15))))
)
