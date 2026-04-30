(defun CreateDoors (n / doors)
  (repeat n
    (setq doors (cons nil doors))
  )
)

(defun Doors (doors / cnt)
  (setq cnt 0)
  (mapcar
   '(lambda (d)
      (zerop (rem (sqrt (setq cnt (1+ cnt))) 1))
    )
    doors
  )
)

> (Doors (CreateDoors 100))
(T nil nil T nil nil nil nil T nil nil nil nil nil nil T nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil T nil nil nil nil)
