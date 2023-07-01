(defparameter *state* (make-list 12))

(defparameter *statements* '(t                                                    ; 1
                             (= (count-true '(7 8 9 10 11 12)) 3)                 ; 2
                             (= (count-true '(2 4 6 8 10 12)) 2)                  ; 3
                             (or (not (p 5)) (and (p 6) (p 7)))                   ; 4
                             (and (not (p 2)) (not (p 3)) (not (p 4)))            ; 5
                             (= (count-true '(1 3 5 7 9 11)) 4)                   ; 6
                             (or (and (p 2) (not (p 3))) (and (not (p 2)) (p 3))) ; 7
                             (or (not (p 7)) (and (p 5) (p 6)))                   ; 8
                             (= (count-true '(1 2 3 4 5 6)) 3)                    ; 9
                             (and (p 11) (p 12))                                  ;10
                             (= (count-true '(7 8 9)) 1)                          ;11
                             (= (count-true '(1 2 3 4 5 6 7 8 9 10 11)) 4)))      ;12

(defun start ()
  (loop while (not (equal *state* '(t t t t t t t t t t t t)))
        do (progn (let ((true-stats (check)))
		       (cond ((= true-stats 11) (result nil))
			     ((= true-stats 12) (result t))))
		  (new-state))))

(defun check ()
  (loop for el in *state*
        for stat in *statements*
        counting (eq el (eval stat)) into true-stats
        finally (return true-stats)))

(defun count-true (lst)
  (loop for i in lst
    counting (nth (- i 1) *state*) into total
    finally (return total)))

(defun p (n)
  (nth (- n 1) *state*))

(defun new-state ()
  (let ((contr t))
       (loop for i from 0 to 11
         do (progn (setf (nth i *state*) (not (eq (nth i *state*) contr)))
                   (setq contr (and contr (not (nth i *state*))))))))

(defun result (?)
  (format t "~:[Missed by one~;Solution:~] ~%~{~:[F~;T~] ~}~%" ? *state*))
