; Use the series approximation to exp(z) to compute e (= exp(1)) to 100 places.

(let*
    ((n 75)
     (p 100)
     (z 1)
     (e (exp z n)))
  (newline)
  (printf "Computing exp(~a) using ~a terms...~%" z n)
  (printf "the computed exact rational:~%~a~%" e)
  (printf "converted to decimal (~a places):~%~a~%" p (rat->dec-str e p))
  (printf "converted to an inexact (float):~%~a~%" (exact->inexact e)))
