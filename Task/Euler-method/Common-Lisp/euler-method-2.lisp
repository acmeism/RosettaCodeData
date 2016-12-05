;; slightly more idiomatic Common Lisp version

(defun newton-cooling (time temperature)
  "Newton's cooling law, f(t,T) = -0.07*(T-20)"
  (declare (ignore time))
  (* -0.07 (- temperature 20)))

(defun euler (f y0 a b h)
  "Euler's Method.
Approximates y(time) in y'(time)=f(time,y) with y(a)=y0 and t=a..b and the step size h."
  (loop for time from a below b by h
        for y = y0 then (+ y (* h (funcall f time y)))
        do (format t "~6,3F  ~6,3F~%" time y)))
