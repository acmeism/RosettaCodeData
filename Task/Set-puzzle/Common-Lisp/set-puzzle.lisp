(defparameter numbers '(one two three))
(defparameter shadings '(solid open striped))
(defparameter colours '(red green purple))
(defparameter symbols '(oval squiggle diamond))

(defun play (&optional (n-cards 9))
  (find-enough-sets n-cards (floor n-cards 2)))

(defun find-enough-sets (n-cards enough)
  (loop
    (let* ((deal (random-sample n-cards (deck)))
           (sets (find-sets deal)))
      (when (>= (length sets) enough)
        (show-cards deal)
        (show-sets sets)
        (return t)))))

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

(defun deck ()
  ;; The deck has to be made only once
  (or (get 'deck 'cards)
      (setf (get 'deck 'cards) (make-deck))))

(defun make-deck ()
  (add-feature numbers
    (add-feature shadings
      (add-feature colours
        (add-feature symbols
          (list '()))))))

(defun add-feature (values deck)
  (mapcan (lambda (value)
             (mapcar (lambda (card) (cons value card))
                     deck))
          values))

;;; Utilities

(defun random-sample (n items)
  (let ((len (length items))
        (taken '()))
    (dotimes (_ n)
      (loop
        (let ((i (random len)))
          (unless (find i taken)
            (setq taken (cons i taken))
            (return)))))
    (mapcar (lambda (i) (nth i items)) taken)))

(defun all-same (values)
  (every #'eql values (rest values)))

(defun all-different (values)
  (every (lambda (v) (= (count v values) 1))
         values))

(defun transpose (rows)
  (apply #'mapcar #'list rows))
