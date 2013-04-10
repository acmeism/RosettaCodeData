;; 't' usually means "true" in CL, but we need 't' here for time/temperature.
(defconstant true 'cl:t)
(shadow 't)


;; Approximates y(t) in y'(t)=f(t,y) with y(a)=y0 and t=a..b and the step size h.
(defun euler (f y0 a b h)

  ;; Set the initial values and increments of the iteration variables.
  (do ((t a  (incf t h))
       (y y0 (incf y (* h (funcall f t y)))))

      ;; End the iteration when t reaches the end b of the time interval.
      ((>= t b) 'DONE)

      ;; Print t and y(t) at every step of the do loop.
      (format true "~6,3F  ~6,3F~%" t y)))


;; Example: Newton's cooling law, f(t,T) = -0.07*(T-20)
(defun newton-cooling (time T) (* -0.07 (- T 20)))

;; Generate the data for all three step sizes (2,5 and 10).
(euler #'newton-cooling 100 0 100  2)
(euler #'newton-cooling 100 0 100  5)
(euler #'newton-cooling 100 0 100 10)
