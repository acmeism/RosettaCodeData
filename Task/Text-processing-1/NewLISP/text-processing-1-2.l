;;  (20.0 "1990-01-01" 1 0)
(define (line->matrix line)
  (letn (fields (parse line {\s+} 0)
         day (pop fields)
         lst)
    (for (i 0 (- (length fields) 1) 2)
      (push (array 4 (list (float (fields i)) day (int (fields (+ i 1))) 0))
        lst -1))
    lst))

(setq all-readings
  (array (* 24 (length all-lines)) 4
         '(0.0 "2000-00-00" 0 0))
  _ nil)

(let (cnt 0)
  (dolist (line all-lines)
    (setq one-day (line->matrix line))
    (dolist (reading one-day)
      (setf (all-readings cnt) reading)
      (++ cnt)))
  'ok)
