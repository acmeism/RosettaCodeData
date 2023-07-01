(defun generate-board ()
  (loop repeat 9 collect nil))

(defparameter *straights* '((1 2 3) (4 5 6) (7 8 9) (1 4 7) (2 5 8) (3 6 9) (1 5 9) (3 5 7)))
(defparameter *current-player* 'x)

(defun get-board-elt (n board)
  (nth (1- n) board))

(defun legal-p (n board)
  (null (get-board-elt n board)))

(defun set-board-elt (n board symbol)
  (if (legal-p n board)
      (setf (nth (1- n) board) symbol)
      (progn (format t "Illegal move. Try again.~&")
	     (set-board-elt (read) board symbol))))

(defun list-legal-moves (board)
  (loop for i from 1 to (length board)
     when (legal-p i board)
     collect i))

(defun get-random-element (lst)
  (nth (random (length lst)) lst))

(defun multi-non-nil-eq (lst)
  (and (notany #'null lst)
       (notany #'null (mapcar #'(lambda (x) (eq (car lst) x)) lst))
       (car lst)))
	
(defun elements-of-straights (board)
  (loop for i in *straights*
     collect (loop for j from 0 to 2
	   collect (get-board-elt (nth j i) board))))

(defun find-winner (board)
  (car (remove-if #'null (mapcar #'multi-non-nil-eq (elements-of-straights board)))))

(defun set-player (mark)
  (format t "Shall a computer play as ~a? (y/n)~&" mark)
  (let ((response (read)))
    (cond ((equalp response 'y) t)
	  ((equalp response 'n) nil)
	  (t (format t "Come again?~&")
	     (set-player mark)))))

(defun player-move (board symbol)
  (format t "~%Player ~a, please input your move.~&" symbol)
  (set-board-elt (read) board symbol)
  (format t "~%"))

(defun computer-move (board symbol)
  (let ((move (get-random-element (list-legal-moves board))))
    (set-board-elt move board symbol)
    (format t "~%computer selects ~a~%~%" move)))

(defun computer-move-p (current-player autoplay-x-p autoplay-o-p)
  (if (eq current-player 'x)
      autoplay-x-p
      autoplay-o-p))

(defun perform-turn (current-player board autoplay-x-p autoplay-o-p)
  (if (computer-move-p current-player autoplay-x-p autoplay-o-p)
      (computer-move board current-player)
      (player-move board current-player)))

(defun switch-player ()
  (if (eq *current-player* 'x)
      (setf *current-player* 'o)
      (setf *current-player* 'x)))

(defun display-board (board)
  (loop for i downfrom 2 to 0
     do (loop for j from 1 to 3
	   initially (format t "|")
	   do (format t "~a|" (or (get-board-elt (+ (* 3 i) j) board) (+ (* 3 i) j)))
	   finally (format t "~&"))))

(defun tic-tac-toe ()
  (setf *current-player* 'x)
  (let ((board (generate-board))
	(autoplay-x-p (set-player 'x))
	(autoplay-o-p (set-player 'o)))
    (format t "~%")
    (loop until (or (find-winner board) (null (list-legal-moves board)))
       do (display-board board)
       do (perform-turn *current-player* board autoplay-x-p autoplay-o-p)
       do (switch-player)
       finally (if (find-winner board)
		   (format t "The winner is ~a!" (find-winner board))
		   (format t "It's a tie.")))))
