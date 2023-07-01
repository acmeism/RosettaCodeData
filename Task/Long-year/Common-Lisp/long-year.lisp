(defun december-31-weekday (year)
   (mod (+ year (floor year 4) (- (floor year 100)) (floor year 400)) 7))

(defun iso-long-year-p (year)
    (or (= 4 (december-31-weekday year)) (= 3 (december-31-weekday (1- year)))))

(format t "Long years between 1800 and 2100:~&~a~%"
    (loop for y from 1800 to 2100 if (iso-long-year-p y) collect y))
