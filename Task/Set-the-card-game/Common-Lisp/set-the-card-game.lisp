(defparameter numbers '(one two three))
(defparameter shadings '(solid open striped))
(defparameter colours '(red green purple))
(defparameter symbols '(oval squiggle diamond))

(defun play (&optional (n-cards 9))
  (let* ((deck (make-deck))
         (deal (take n-cards (shuffle deck)))
         (sets (find-sets deal)))
    (show-cards deal)
    (show-sets sets)))

(defun show-cards (cards)
  (format t "~D cards~%~{~(~{~10S~}~)~%~}~%"
          (length cards) cards))

(defun show-sets (sets)
  (format t "~D sets~2%~:{~(~@{~{~8S~}~%~}~)~%~}"
          (length sets) sets))

(defun find-sets (deal)
  (remove-if-not #'is-set (combinations 3 deal)))

(defun is-set (cards)
  (every #'feature-makes-set (transpose cards)))

(defun feature-makes-set (feature-values)
  (or (all-same feature-values)
      (all-different feature-values)))

(defun combinations (n items)
  (cond
    ((zerop n) '(()))
    ((null items) '())
    (t (append
          (mapcar (lambda (c) (cons (car items) c))
                  (combinations (1- n) (cdr items)))
          (combinations n (cdr items))))))

;;; Making a deck

(defun make-deck ()
  (let ((deck (make-array (list (expt 3 4))))
        (i -1))
    (dolist (n numbers deck)
      (dolist (sh shadings)
        (dolist (c colours)
          (dolist (sy symbols)
            (setf (svref deck (incf i))
                  (list n sh c sy))))))))

;;; Utilities

(defun shuffle (deck)
  (loop for i from (1- (length deck)) downto 0
        do (rotatef (elt deck i)
                    (elt deck (random (1+ i))))
        finally (return deck)))

(defun take (n seq)  ;  returns a list
  (loop for i from 0 below n
        collect (elt seq i)))

(defun all-same (values)
  (every #'eql values (rest values)))

(defun all-different (values)
  (every (lambda (v) (= (count v values) 1))
         values))

(defun transpose (list-of-rows)
  (apply #'mapcar #'list list-of-rows))
