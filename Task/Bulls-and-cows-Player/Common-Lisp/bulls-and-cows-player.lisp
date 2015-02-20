(defun random-number ()
  (do* ((lst '(1 2 3 4 5 6 7 8 9) (remove d lst))
        (l 9 (length lst))
        (d (nth (random l) lst) (nth (random l) lst))
        (number nil (cons d number)))
       ((= l 5) number)))

(defun validp (number)
  (loop for el in number with rst = (rest number)
        do (cond ((= el 0) (return-from validp nil))
                 ((member el rst) (return-from validp nil))
                 (t (setq rst (rest rst))))
        finally (return number)))

(defun bulls (number guess)
  (loop for x in number
        for y in guess
        counting (= x y) into b
        finally (return b)))

(defun bulls+cows (number guess)
  (loop for x in guess
        counting (member x number) into c
        finally (return c)))

(defun solve ()
  (let ((number (random-number))
        (possible-guesses (loop for i from 1234 to 9876
                                when (validp (map 'list #'digit-char-p (prin1-to-string i))) collect it)))
       (format t "Secret: ~a~%" number)
       (loop with guess = (nth (random (length possible-guesses)) possible-guesses)
             with b = (bulls number guess)
             with c = (- (bulls+cows number guess) b)
             do  (format t "Guess:  ~a B: ~a C: ~a~%" guess b c)
                 (if (= b 4)
                   (return-from solve (format t "Solution found!")))
                 (setq possible-guesses (mapcan #'(lambda (x) (if (and (= b (bulls x guess))
								       (= c (- (bulls+cows x guess) b)))
							        (list x)))
						(remove guess possible-guesses)))
                 (setq guess (nth (random (length possible-guesses)) possible-guesses))
                 (setq b (bulls number guess))
                 (setq c (- (bulls+cows number guess) b)))))
