(defun queens (nmax)
   (let ((a (make-array `(,nmax)))
         (s (make-array `(,nmax)))
         (u (make-array `(,(- (* 4 nmax) 2)) :initial-element 0))
         y z i j p q r m (v nil))
      (dotimes (i nmax) (setf (aref a i) i))
      (loop for n from 1 to nmax do
         (tagbody
            (setf m 0 i 0 r (1- (* 2 n)))
            (go L40)
            L30
            (setf (aref s i) j (aref u p) 1 (aref u (+ q r)) 1)
            (incf i)
            L40
            (if (>= i n) (go L80))
            (setf j i)
            L50
            (setf y (aref a j) z (aref a i))
            (setf p (+ (- i y) (1- n)) q (+ i y))
            (setf (aref a i) y (aref a j) z)
            (if (and (zerop (aref u p)) (zerop (aref u (+ q r)))) (go L30))
            L60
            (incf j)
            (if (< j n) (go L50))
            L70
            (decf j)
            (if (= j i) (go L90))
            (rotatef (aref a i) (aref a j))
            (go L70)
            L80
            (incf m)
            L90
            (decf i)
            (if (minusp i) (go L100))
            (setf p (+ (- i (aref a i)) (1- n)) q (+ i (aref a i)) j (aref s i))
            (setf (aref u p) 0 (aref u (+ q r)) 0)
            (go L60)
            L100
            ;(princ n) (princ " ") (princ m) (terpri)
            (push (cons n m) v)
            )) (reverse v)))

> (queens 14)
((1 . 1) (2 . 0) (3 . 0) (4 . 2) (5 . 10) (6 . 4) (7 . 40) (8 . 92) (9 . 352)
 (10 . 724) (11 . 2680) (12 . 14200) (13 . 73712) (14 . 365596))
