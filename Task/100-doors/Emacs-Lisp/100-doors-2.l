(defun one-hundred-doors(initial-state)
  "Turn doors in INITIAL-STATE according to 100 Doors problem."
  (interactive "nEnter initial doors' state (as a number): ")
  (cl-loop for x from 1 to 100
           do (cl-loop for y from (1- x) to 99 by x
                       do (setq initial-state (logxor initial-state (ash 1 y)))))
  (let ((counter 1)
        (open-doors nil))
    (while (> initial-state 0)
      (when (eq (mod initial-state 2) 1)
        (push counter open-doors))
      (cl-incf counter)
      (setq initial-state (/ initial-state 2)))
    (message "Open doors are %s" (reverse open-doors))))

(one-hundred-doors 0)
