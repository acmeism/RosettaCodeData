(ql:quickload '(cffi alexandria))

(defpackage :2048-lisp
  (:use :common-lisp :cffi :alexandria))

(in-package :2048-lisp)

(defvar *lib-loaded* nil)

(unless *lib-loaded*
  ;; Load msvcrt.dll to access _getch.
  (define-foreign-library msvcrt
    (:windows (:default "msvcrt")))

  (use-foreign-library msvcrt)

  (defcfun "_getch" :int)

  (setf *lib-loaded* t))

(defun read-arrow ()
  "Get an arrow key from input as UP, DOWN, LEFT, or RIGHT, otherwise
return a char of whatever was pressed."
  (let ((first-char (-getch)))
    (if (= 224 first-char)
        (case (-getch)
          (75 'left)
          (80 'down)
          (77 'right)
          (72 'up))
        (code-char first-char))))

(defmacro swap (place1 place2)
  "Exchange the values of two places."
  (let ((temp (gensym "TEMP")))
    `(cl:let ((,temp ,place1))
       (cl:setf ,place1 ,place2)
       (cl:setf ,place2 ,temp))))

(defun nflip (board &optional (left-right t))
  "Flip the elements of a BOARD left and right or optionally up and down."
  (let* ((y-len (array-dimension board 0))
         (x-len (array-dimension board 1))
         (y-max (if left-right y-len (truncate y-len 2)))
         (x-max (if left-right (truncate x-len 2) x-len)))
    (loop for y from 0 below y-max
       for y-place = (- y-len 1 y) do
         (loop for x from 0 below x-max
            for x-place = (- x-len 1 x) do
              (if left-right
                  (swap (aref board y x) (aref board y x-place))
                  (swap (aref board y x) (aref board y-place x)))))
    board))

(defun flip (board &optional (left-right t))
  "Flip the elements of a BOARD left and right or optionally up and down.
Non-destructive version."
  (nflip (copy-array board) left-right))

(defun transpose (board)
  "Transpose the elements of BOARD into a new array."
  (let* ((y-len (array-dimension board 0))
         (x-len (array-dimension board 1))
         (new-board (make-array (reverse (array-dimensions board)))))
    (loop for y from 0 below y-len do
         (loop for x from 0 below x-len do
              (setf (aref new-board x y) (aref board y x))))
    new-board))

(defun add-random-piece (board)
  "Find a random empty spot on the BOARD to add a new piece.
Return T if successful, NIL otherwise."
  (loop
     for x from 0 below (array-total-size board)
     unless (row-major-aref board x)
     count 1 into count
     and collect x into indices
     finally
       (unless (= 0 count)
         (setf (row-major-aref board (nth (random count) indices))
               (if (= 0 (random 10)) 4 2))
         (return t))))

(defun squash-line (line)
  "Reduce a sequence of numbers from left to right according to
the rules of 2048. Return the score of squashing as well."
  (let* ((squashed
          (reduce
           (lambda (acc x)
             (if (equal x (car acc))
                 (cons (list (* 2 x)) (cdr acc))
                 (cons x acc)))
           (nreverse (remove-if #'null line))
           :initial-value nil))
         (new-line (flatten squashed)))
    (list (append (make-list (- (length line) (length new-line))) new-line)
          (reduce #'+ (flatten (remove-if-not #'listp squashed))))))

(defun squash-board (board)
  "Reduce each row of a board from left to right according to
the rules of 2048. Return the total score of squashing the board as well."
  (let ((y-len (array-dimension board 0))
        (x-len (array-dimension board 1))
        (total 0))
    (list (make-array (array-dimensions board) :initial-contents
                      (loop for y from 0 below y-len
                         for (line score) =
                           (squash-line
                            (make-array x-len
                                        :displaced-to board
                                        :displaced-index-offset
                                        (array-row-major-index board y 0)))
                         collect line
                         do (incf total score)))
          total)))

(defun make-move (board direction)
  "Make a move in the given DIRECTION on a new board."
  ;; Move by always squashing right, but transforming the board as needed.
  (destructuring-bind (new-board score)
      (case direction
        (up (squash-board (flip (transpose board))))
        (down (squash-board (flip (transpose board) nil)))
        (left (squash-board (nflip (flip board nil))))
        (right (squash-board board)))
    (let ((new-board
           ;; Reverse the transformation.
           (case direction
             (up (transpose (nflip new-board)))
             (down (transpose (nflip new-board nil)))
             (left (nflip (nflip new-board nil)))
             (right new-board))))
      (unless (equalp board new-board)
        (add-random-piece new-board)
        (list new-board score)))))

(defun winp (board winning-tile)
  "Determine if a BOARD is in a winning state."
  (loop for x from 0 below (array-total-size board)
     for val = (row-major-aref board x)
     when (eql val winning-tile) do (return t)))

(defun game-overp (board)
  "Determine if a BOARD is in a game over state."
  ;; If a move is simulated in every direction and nothing changes,
  ;; then we can assume there are no valid moves left.
  (notany (lambda (dir) (car (make-move board dir)))
          '(up down left right)))

(defun print-divider (cells cell-size)
  "A print helper function for PRINT-BOARD."
  (dotimes (_ cells)
    (princ "+")
    (dotimes (_ cell-size)
      (princ "-")))
  (princ "+")
  (terpri))

(defun print-board (board cell-size)
  "Pretty print the given BOARD with a particular CELL-SIZE."
  (let* ((y-len (array-dimension board 0))
         (x-len (array-dimension board 1))
         (super-size (+ 2 cell-size)))
    (loop for y from 0 below y-len do
         (print-divider x-len super-size)
         (loop for x from 0 below x-len
            for val = (aref board y x)
            do
              (princ "|")
              (if val
                  (format t " ~VD " cell-size val)
                  (dotimes (_ super-size) (princ " "))))
         (princ "|")
         (terpri))
    (print-divider x-len super-size)))

(defun init-board ()
  (let ((board (make-array '(4 4) :initial-element nil)))
    (setf (row-major-aref board (random (array-total-size board))) 2)
    board))

(defun prompt-input (board score &optional (check t))
  (cond
    ((and check (winp board 2048)) (format t "You win!"))
    ((and check (game-overp board)) (format t "Game over..."))
    (t (let ((choice (read-arrow)))
         (cond
           ((symbolp choice)
            (destructuring-bind (&optional move (new-score 0))
                (make-move board choice)
              (if move
                  (prompt move (+ score new-score))
                  (prompt-input board score))))
           ((find choice "qQ")
            (format t "Quitting."))
           (t (prompt-input board score nil)))))))

(defun prompt (&optional (board (init-board)) (score 0))
  (format t "~%   Score: ~D~%" score)
  (print-board board 4)
  (prompt-input board score))
