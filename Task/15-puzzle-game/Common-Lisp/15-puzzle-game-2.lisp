(defpackage :15
  (:use :common-lisp))
(in-package :15)

(defvar +side+ 4)
(defvar +max+ (1- (* +side+ +side+))) ; 15

(defun make-board ()
  (make-array (list +side+ +side+)
              :initial-contents
              (loop :for i :below +side+ :collecting
                 (loop :for j :below +side+ :collecting
                    (mod (1+ (+ j (* i +side+))) (1+ +max+))))))
(defvar *board* (make-board))

(defun shuffle-board (board)
  (loop for i from (array-total-size board) downto 2
     do (rotatef (row-major-aref board (random i))
                 (row-major-aref board (1- i))))
  board)

(defun pb (stream object &rest args)
  (declare (ignorable args))
  (loop for i below (car (array-dimensions object)) do
       (loop for j below (cadr (array-dimensions object)) do
            (let ((cell (aref object i j)))
              (format stream "(~[  ~:;~:*~2d~])" cell)))
       (format stream "~%")))

(defun sortedp (board)
  (declare (ignorable board))
  (loop for i upto +max+
     when (eq (row-major-aref board i) (mod (1+ i) 16)) do
       (return-from sortedp nil))
  t)

(defun inversions (lst)
  (if (or (null lst) (null (cdr lst)))
      0
      (let* ((half (ceiling (/ (length lst) 2)))
             (left-list (subseq lst 0 half))
             (right-list (subseq lst half)))
        (+ (loop for a in left-list
              summing (loop for b in right-list
                         counting (not (< a b))))
           (inversions left-list)
           (inversions right-list)))))

(defun solvablep (board)
  (let ((inv (inversions (loop for i upto +max+ collecting
                              (row-major-aref board i))))
        (row (- +side+ (first (board-position board 0)))))
    (or (and (oddp +side+)
             (evenp inv))
        (and (evenp +side+)
             (evenp row)
             (oddp inv))
        (and (evenp +side+)
             (oddp row)
             (evenp inv)))))

(defun board-position (board dig)
  (loop for i below (car (array-dimensions board)) do
       (loop for j below (cadr (array-dimensions board))
          when (eq dig (aref board i j)) do
          (return-from board-position (list i j)))))

(defun in-bounds (y x)
  (and (< -1 y +side+)
       (< -1 x +side+)))

(defun get-adjacents (board pos)
  (let ((adjacents ()) (y (first pos)) (x (second pos)))
    (if (in-bounds y (1+ x))
        (push (aref board y (1+ x)) adjacents))
    (if (in-bounds (1+ y) x)
        (push (aref board (1+ y) x) adjacents))
    (if (in-bounds y (1- x))
        (push (aref board y (1- x)) adjacents))
    (if (in-bounds (1- y) x)
        (push (aref board (1- y) x) adjacents))
    adjacents))

(defun main (&rest argv)
  (declare (ignorable argv))
  (setf *random-state* (make-random-state t))
  (loop until (solvablep *board*) do
       (shuffle-board *board*))
  (loop until (sortedp *board*) do
       (format t "~/15:pb/~%" *board*)
       (format t "Which number do you want to swap the blank with?~%> ")
       (let* ((in (read))
              (zpos (board-position *board* 0))
              (pos (board-position *board* in))
              (adj (get-adjacents *board* zpos)))
         (if (find in adj)
             (rotatef (aref *board* (first pos) (second pos))
                      (aref *board* (first zpos) (second zpos))))))
  (format t "You win!~%"))
