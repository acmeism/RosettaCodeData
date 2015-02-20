(defun to-celsius (k)
  (- k 273.15))
(defun to-fahrenheit (k)
  (- (* k 1.8) 459.67))
(defun to-rankine (k)
  (* k 1.8))

(defun temperature-conversion ()
  (let ((k (read)))
    (if (numberp k)
      (format t "Celsius: ~d~%Fahrenheit: ~d~%Rankine: ~d~%"
        (to-celsius k) (to-fahrenheit k) (to-rankine k))
      (format t "Error: Non-numeric value entered."))))
