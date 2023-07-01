(loop for i from 1 to 1000
      collect (1+ (* (sqrt (* -2 (log (random 1.0)))) (cos (* 2 pi (random 1.0))) 0.5)))
