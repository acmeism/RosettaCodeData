(let* ((r (nth-root 3 10))
       (rf (coerce r 'float)))
  (print (* r r r ))
  (print (* rf rf rf)))
