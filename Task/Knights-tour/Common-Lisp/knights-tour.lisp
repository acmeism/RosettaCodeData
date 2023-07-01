;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;   Solving the knight's tour.                     ;;;
;;;   Warnsdorff's rule with random tie break.       ;;;
;;;   Optionally outputs a closed tour.              ;;;
;;;   Options from interactive prompt.               ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *side* 8)

(defun generate-chessboard (n)
  (loop for i below n append
    (loop for j below n collect (complex i j))))

(defparameter *chessboard*
  (generate-chessboard *side*))

(defun complex->algebraic (n)
;; returns a string like "b2"
  (concatenate 'string
    ;; 'a' is char #97: add it to the offset
    (string (character  (+ 97 (realpart n))))
    ;; indices start at 0, but algebraic starts at 1
    (string (digit-char (+ 1  (imagpart n))))))

(defun algebraic->complex (string)
;; takes a string like "e4"
  (let ((row (char string 0))
        (col (char string 1)))
    (complex (- (char-code row) 97)
             (- (digit-char-p col) 1))))

(defconstant *knight-directions*
  (list
    (complex  1  2)
    (complex  2  1)
    (complex  1 -2)
    (complex  2 -1)
    (complex -1  2)
    (complex -2  1)
    (complex -1 -2)
    (complex -2 -1)))

(defun find-legal-moves (moves-list)
  ;; 2. the move must not be on a case already visited
  (remove-if (lambda (m) (member m moves-list))
    ;; 1. the move must be within the chessboard
    (intersection
      (mapcar (lambda (i) (+ (car moves-list) i)) *knight-directions*)
      *chessboard*)))


;; Select between two moves by Warnsdorff's rule:
;; pick the one with the lowest index or else
;; randomly break the tie.
;; Takes a cons in the form (n . #C(x y)).
;; This will be the sorting rule for picking the next move.
(defun w-rule (a b)
 (cond ((< (car a) (car b)) t)
       ((> (car a) (car b)) nil)
       ((= (car a) (car b))
         (zerop (random 2)))))

;; For every legal move in a given position,
;; look forward one move and return a cons
;; in the form (n . #C(x y)) where n is
;; how many next free moves follow the first move.
(defun return-weighted-moves (moves)
  (let ((candidates (find-legal-moves moves)))
    (loop for mv in candidates collect
      (cons
        (list-length (find-legal-moves (cons mv moves)))
        mv))))

;; Given a list of weighted moves (as above),
;; pick one according to the w-rule
(defun pick-among-weighted-moves (moves)
  ;; prune dead ends one move early
  (let ((possible-moves
          (remove-if (lambda(m) (zerop (car m))) moves)))
    (cdar (sort possible-moves #'w-rule))))

(defun make-move (moves-list)
    (let ((next-move
            (if (< (list-length moves-list) (1- (list-length *chessboard*)))
              (pick-among-weighted-moves (return-weighted-moves moves-list))
              (car (find-legal-moves moves-list)))))
      (cons next-move moves-list)))

(defun make-tour (moves-list)
;; takes a list of moves as an argument
  (if (null (car moves-list)) ; last move not found: start over
    (make-tour (last moves-list))
    (if (= (list-length moves-list) (list-length *chessboard*))
      moves-list
      (make-tour (make-move moves-list)))))

(defun make-closed-tour (moves-list)
  (let ((tour (make-tour moves-list)))
    (if (tour-closed-p tour)
      tour
      (make-closed-tour moves-list))))

(defun tour-closed-p (tour)
;; takes a full tour as an argument
  (let ((start (car (last tour)))
        (end (car tour)))
    ;; is the first position a legal move, when
    ;; viewed from the last move?
    (if (member start (find-legal-moves (list end))) ; find-legal-moves takes a list
      t nil)))

(defun print-tour-linear (tour)
;; takes a tour (moves list) with the last move first
;; and prints it nicely in algebraic notation
  (let ((moves (mapcar #'complex->algebraic (reverse tour))))
    (format t "~{~A~^ -> ~}" moves)))

(defun tour->matrix (tour)
;; takes a tour and makes a row-by-row 2D matrix
;; from top to bottom (for further formatting & printing)
  (flet ((index-tour (tour) ; 1st local function
           (loop for i below (length tour)
             ;; starting from index 1, not 0, so add 1;
             ;; reverse because the last move is still in the car
             collect (cons (nth i (reverse tour)) (1+ i))))
         (get-row (n tour)  ; 2nd local function
           ;; in every row, the imaginary part (vertical offset) stays the same
           (remove-if-not (lambda (e) (= n (imagpart (car e)))) tour)))
    (let* ((indexed-tour (index-tour tour))
           (ordered-indexed-tour
           ;; make a list of ordered rows
             (loop for i from (1- *side*) downto 0 collect
               (sort (get-row i indexed-tour)
                     (lambda (a b) (< (realpart (car a)) (realpart (car b))))))))
      ;; clean up, leaving only the indices
      (mapcar (lambda (e) (mapcar #'cdr e)) ordered-indexed-tour))))

(defun print-tour-matrix (tour)
  (mapcar (lambda (row)
    (format t "~{~3d~}~&" row)) (tour->matrix tour)))

;;; Handling options

(defstruct options
           closed
           start
           grid)

(defparameter *opts* (make-options))

;;; Interactive part

(defun prompt()
  (format t "Starting case (leave blank for random)? ")
  (let ((start (string (read-line))))
    (if (member start (mapcar #'complex->algebraic *chessboard*) :test #'equal)
      (setf (options-start *opts*) start))
  (format t "Require a closed tour (yes or default to no)? ")
  (let ((closed (read-line)))
    (if (or (equal closed "y") (equal closed "yes"))
      (setf (options-closed *opts*) t)))))

(defun main ()
  (let* ((start
           (if (options-start *opts*)
             (algebraic->complex (options-start *opts*))
             (complex (random *side*) (random *side*))))
         (closed (options-closed *opts*))
         (tour
           (if closed
             (make-closed-tour (list start))
             (make-tour (list start)))))
    (fresh-line)
    (if closed (princ "Closed "))
    (princ "Knight's tour")
    (if (options-start *opts*)
      (princ ":")
      (princ " (starting on a random case):"))
    (fresh-line)
    (print-tour-linear tour)
    (princ #\newline)
    (princ #\newline)
    (print-tour-matrix tour)))

;;; Good to go: invocation!

(prompt)
(main)
