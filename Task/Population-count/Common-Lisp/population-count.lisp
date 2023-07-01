(format T "3^x: ~{~a ~}~%"
        (loop for i below 30
              collect (logcount (expt 3 i))))

(multiple-value-bind
  (evil odious)
  (loop for i below 60
        if (evenp (logcount i)) collect i into evil
        else collect i into odious
        finally (return (values evil odious)))
  (format T "evil: ~{~a ~}~%" evil)
  (format T "odious: ~{~a ~}~%" odious))
