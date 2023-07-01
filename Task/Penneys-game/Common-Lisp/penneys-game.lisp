(setf *random-state* (make-random-state t))

(defparameter *heads* #\H)
(defparameter *tails* #\T)

(defun main ()
  (format t "Penney's Game~%~%")
  (format t "Flipping to see who goes first ...")

  (setq p2 nil)
  (if (string= (flip) *heads*)
      (progn (format t " I do.~%")
             (setq p2 (choose-random-sequence))
             (format t "I choose: ~A~%" p2))
      (format t "You do.~%"))

  (setq p1 nil)
  (loop while (null p1) doing
    (format t "Enter your three-flip sequence: ")
    (setq p1 (string (read)))
    (cond ((/= (length p1) 3)
           (format t "Sequence must consist of three flips.~%")
           (setq p1 nil))
          ((string= p1 p2)
           (format t "Sequence must be different from mine.~%")
           (setq p1 nil))
          ((notevery #'valid? (coerce p1 'list))
           (format t "Sequence must be contain only ~A's and ~A's.~%" *heads* *tails*)
           (setq p1 nil))))
  (format t "You picked: ~A~%" p1)

  (if (null p2)
    (progn
      (setq p2 (choose-optimal-sequence p1))
      (format t "I choose: ~A~%" p2)))

  (format t "Here we go. ~A, you win; ~A, I win.~%" p1 p2)
  (format t "Flips:")
  (let ((winner nil)
        (flips '()))
    (loop while (null winner) doing
      (setq flips (cons (flip) flips))
      (format t " ~A" (car flips))
      (if (>= (length flips) 3)
        (let ((trail (coerce (reverse (subseq flips 0 3)) 'string)))
          (cond ((string= trail p1) (setq winner "You"))
                ((string= trail p2) (setq winner "I"))))))
    (format t "~&~A win!" winner)))

(defparameter *sides* (list *heads* *tails*))
(defun flip () (nth (random 2 *random-state*) *sides*))

(defun valid? (flip) (not (null (member flip *sides*))))

(defun opposite (flip) (if (string= flip *heads*) *tails* *heads*))

(defun choose-random-sequence () (coerce (list (flip) (flip) (flip)) 'string))

(defun choose-optimal-sequence (against)
  (let* ((opposed (coerce against 'list))
         (middle  (cadr opposed))
         (my-list (list (opposite middle) (car opposed) middle)))
    (coerce my-list 'string)))

(main)
