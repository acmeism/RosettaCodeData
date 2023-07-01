(defun pascal-lower (n &aux (a (make-array (list n n) :initial-element 0)))
    (dotimes (i n)
        (setf (aref a i 0) 1))
    (dotimes (i (1- n) a)
        (dotimes (j (1- n))
            (setf (aref a (1+ i) (1+ j))
                (+ (aref a i j)
                   (aref a i (1+ j)))))))

(defun pascal-upper (n &aux (a (make-array (list n n) :initial-element 0)))
    (dotimes (i n)
        (setf (aref a 0 i) 1))
    (dotimes (i (1- n) a)
        (dotimes (j (1- n))
            (setf (aref a (1+ j) (1+ i))
                (+ (aref a j i)
                   (aref a (1+ j) i))))))

(defun pascal-symmetric (n &aux (a (make-array (list n n) :initial-element 0)))
    (dotimes (i n)
        (setf (aref a i 0) 1 (aref a 0 i) 1))
    (dotimes (i (1- n) a)
        (dotimes (j (1- n))
            (setf (aref a (1+ i) (1+ j))
                (+ (aref a (1+ i) j)
                   (aref a i (1+ j)))))))

? (pascal-lower 4)
#2A((1 0 0 0) (1 1 0 0) (1 2 1 0) (1 3 3 1))
? (pascal-upper 4)
#2A((1 1 1 1) (0 1 2 3) (0 0 1 3) (0 0 0 1))
? (pascal-symmetric 4)
#2A((1 1 1 1) (1 2 3 4) (1 3 6 10) (1 4 10 20))

;In case one really insists in printing the array row by row:

(defun print-matrix (a)
    (let ((p (array-dimension a 0))
          (q (array-dimension a 1)))
        (dotimes (i p)
            (dotimes (j q)
                (princ (aref a i j))
                (princ #\Space))
            (terpri))))

? (print-matrix (pascal-lower 5))
1 0 0 0 0
1 1 0 0 0
1 2 1 0 0
1 3 3 1 0
1 4 6 4 1

? (print-matrix (pascal-upper 5))
1 1 1 1 1
0 1 2 3 4
0 0 1 3 6
0 0 0 1 4
0 0 0 0 1

? (print-matrix (pascal-symmetric 5))
1 1 1 1 1
1 2 3 4 5
1 3 6 10 15
1 4 10 20 35
1 5 15 35 70
