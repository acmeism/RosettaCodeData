(defun queens1 (n)
    (let ((a (make-array n))
          (s (make-array n))
          (u (make-array (list (- (* 4 n) 2)) :initial-element t))
          y z (i 0) j p q (r (1- (* 2 n))) (m 0))
        (dotimes (i n) (setf (aref a i) i))
        (tagbody
            L1
            (if (>= i n) (go L5))
            (setf j i)
            L2
            (setf y (aref a j) z (aref a i))
            (setf p (+ (- i y) n -1) q (+ i y))
            (setf (aref a i) y (aref a j) z)
            (when (and (aref u p) (aref u (+ q r)))
                (setf (aref s i) j (aref u p) nil (aref u (+ q r)) nil)
                (incf i)
                (go L1))
            L3
            (incf j)
            (if (< j n) (go L2))
            L4
            (decf j)
            (if (= j i) (go L6))
            (rotatef (aref a i) (aref a j))
            (go L4)
            L5
            (incf m)
            L6
            (decf i)
            (if (minusp i) (go L7))
            (setf p (+ (- i (aref a i)) n -1) q (+ i (aref a i)) j (aref s i))
            (setf (aref u p) t (aref u (+ q r)) t)
            (go L3)
            L7)
        m))

> (loop for n from 1 to 14 collect (cons n (queens1 n)))
((1 . 1) (2 . 0) (3 . 0) (4 . 2) (5 . 10) (6 . 4) (7 . 40) (8 . 92) (9 . 352)
 (10 . 724) (11 . 2680) (12 . 14200) (13 . 73712) (14 . 365596))
