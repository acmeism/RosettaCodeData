(let ((val 0))
  (loop do
        (incf val)
        (print val)
        while (/= 0 (mod val 6))))
