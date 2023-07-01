;Find out how often we win if we always switch
(defun rand-elt (s)
  (elt s (random (length s))))

(defun monty ()
  (let* ((doors '(0 1 2))
	 (prize (random 3));possible values: 0, 1, 2
	 (pick (random 3))
	 (opened (rand-elt (remove pick (remove prize doors))));monty opens a door which is not your pick and not the prize
	 (other (car (remove pick (remove opened doors)))))	 ;you decide to switch to the one other door that is not your pick and not opened
    (= prize other))) ; did you switch to the prize?

(defun monty-trials (n)
  (count t (loop for x from 1 to n collect (monty))))
