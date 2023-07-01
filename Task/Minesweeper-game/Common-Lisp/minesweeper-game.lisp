(defclass minefield ()
  ((mines :initform (make-hash-table :test #'equal))
   (width :initarg :width)
   (height :initarg :height)
   (grid :initarg :grid)))

(defun make-minefield (width height num-mines)
  (let ((minefield (make-instance 'minefield
                                  :width width
                                  :height height
                                  :grid (make-array
                                          (list width height)
                                          :initial-element #\.)))
        (mine-count 0))
    (with-slots (grid mines) minefield
      (loop while (< mine-count num-mines)
            do (let ((coords (list (random width) (random height))))
                 (unless (gethash coords mines)
                   (setf (gethash coords mines) T)
                   (incf mine-count))))
      minefield)))

(defun print-field (minefield)
  (with-slots (width height grid) minefield
    (dotimes (y height)
      (dotimes (x width)
        (princ (aref grid x y)))
      (format t "~%"))))

(defun mine-list (minefield)
  (loop for key being the hash-keys of (slot-value minefield 'mines) collect key))

(defun count-nearby-mines (minefield coords)
  (length (remove-if-not
            (lambda (mine-coord)
              (and
                (> 2 (abs (- (car coords) (car mine-coord))))
                (> 2 (abs (- (cadr coords) (cadr mine-coord))))))
            (mine-list minefield))))

(defun clear (minefield coords)
  (with-slots (mines grid) minefield
    (if (gethash coords mines)
      (progn
        (format t "MINE! You lose.~%")
        (dolist (mine-coords (mine-list minefield))
          (setf (aref grid (car mine-coords) (cadr mine-coords)) #\x))
        (setf (aref grid (car coords) (cadr coords)) #\X)
        nil)
      (setf (aref grid (car coords) (cadr coords))
            (elt " 123456789"(count-nearby-mines minefield coords))))))

(defun mark (minefield coords)
  (with-slots (mines grid) minefield
    (setf (aref grid (car coords) (cadr coords)) #\?)))

(defun win-p (minefield)
  (with-slots (width height grid mines) minefield
    (let ((num-uncleared 0))
      (dotimes (y height)
        (dotimes (x width)
          (let ((square (aref grid x y)))
            (when (member square '(#\. #\?) :test #'char=)
              (incf num-uncleared)))))
      (= num-uncleared (hash-table-count mines)))))

(defun play-game ()
  (let ((minefield (make-minefield 6 4 5)))
    (format t "Greetings player, there are ~a mines.~%"
            (hash-table-count (slot-value minefield 'mines)))
    (loop
      (print-field minefield)
      (format t "Enter your command, examples: \"clear 0 1\" \"mark 1 2\" \"quit\".~%")
      (princ "> ")
      (let ((user-command (read-from-string (format nil "(~a)" (read-line)))))
        (format t "Your command: ~a~%" user-command)
        (case (car user-command)
          (quit (return-from play-game nil))
          (clear (unless (clear minefield (cdr user-command))
                   (print-field minefield)
                   (return-from play-game nil)))
          (mark (mark minefield (cdr user-command))))
        (when (win-p minefield)
          (format t "Congratulations, you've won!")
          (return-from play-game T))))))

(play-game)
