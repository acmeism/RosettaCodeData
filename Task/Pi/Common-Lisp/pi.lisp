(defun pi-spigot ()
  (labels
      ((g (q r t1 k n l)
         (cond
           ((< (- (+ (* 4 q) r) t1)
               (* n t1))
            (princ n)
            (g (* 10 q)
               (* 10 (- r (* n t1)))
               t1
               k
               (- (floor (/ (* 10 (+ (* 3 q) r))
                            t1))
                  (* 10 n))
               l))
           (t
            (g (* q k)
               (* (+ (* 2 q) r) l)
               (* t1 l)
               (+ k 1)
               (floor (/ (+ (* q (+ (* 7 k) 2))
                            (* r l))
                         (* t1 l)))
               (+ l 2))))))
    (g 1 0 1 1 3 3)))
