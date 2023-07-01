(defun determinant (rows &optional (skip-cols nil))
  (let* ((result 0) (sgn -1))
    (dotimes (col (length (car rows)) result)
      (unless (member col skip-cols)
        (if (null (cdr rows))
          (return-from determinant (elt (car rows) col))
          (incf result (* (setq sgn (- sgn)) (elt (car rows) col) (determinant (cdr rows) (cons col skip-cols)))) )))))

(defun permanent (rows &optional (skip-cols nil))
  (let* ((result 0))
    (dotimes (col (length (car rows)) result)
      (unless (member col skip-cols)
        (if (null (cdr rows))
          (return-from permanent (elt (car rows) col))
          (incf result (* (elt (car rows) col) (permanent (cdr rows) (cons col skip-cols)))) )))))


Test using the first set of definitions (from task description):

(setq m2
  '((1 2)
    (3 4)))

(setq m3
  '((-2 2 -3)
    (-1 1  3)
    ( 2 0 -1)))

(setq m4
  '(( 1  2  3  4)
    ( 4  5  6  7)
    ( 7  8  9 10)
    (10 11 12 13)))

(setq m5
  '(( 0  1  2  3  4)
    ( 5  6  7  8  9)
    (10 11 12 13 14)
    (15 16 17 18 19)
    (20 21 22 23 24)))

(dolist (m (list m2 m3 m4 m5))
  (format t "~a determinant: ~a, permanent: ~a~%" m (determinant m) (permanent m)) )
