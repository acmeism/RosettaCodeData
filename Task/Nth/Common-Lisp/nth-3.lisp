(loop for (low high) in '((0 25) (250 265) (1000 1025))
      do (progn
           (format t "~a to ~a: " low high)
           (loop for n from low to high
                 do (format t "~a " (add-suffix n))
                 finally (terpri))))
