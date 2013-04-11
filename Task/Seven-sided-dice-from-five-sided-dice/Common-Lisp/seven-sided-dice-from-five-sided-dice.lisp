(defun d5 ()
  (1+ (random 5)))

(defun d7 ()
  (loop for d55 = (+ (* 5 (d5)) (d5) -6)
        until (< d55 21)
        finally (return (1+ (mod d55 7)))))
