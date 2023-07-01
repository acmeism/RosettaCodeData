(defun next-combination (n a)
    (let ((k (length a)) m)
    (loop for i from 1 do
        (when (> i k) (return nil))
        (when (< (aref a (- k i)) (- n i))
            (setf m (aref a (- k i)))
            (loop for j from i downto 1 do
                (incf m)
                (setf (aref a (- k j)) m))
            (return t)))))

(defun all-combinations (n k)
    (if (or (< k 0) (< n k)) '()
        (let ((a (make-array k)))
            (loop for i below k do (setf (aref a i) i))
            (loop collect (coerce a 'list) while (next-combination n a)))))

(defun map-combinations (n k fun)
    (if (and (>= k 0) (>= n k))
        (let ((a (make-array k)))
            (loop for i below k do (setf (aref a i) i))
            (loop do (funcall fun (coerce a 'list)) while (next-combination n a)))))

; all-combinations returns a list of lists

> (all-combinations 4 3)
((0 1 2) (0 1 3) (0 2 3) (1 2 3))

; map-combinations applies a function to each combination

> (map-combinations 6 4 #'print)
(0 1 2 3)
(0 1 2 4)
(0 1 2 5)
(0 1 3 4)
(0 1 3 5)
(0 1 4 5)
(0 2 3 4)
(0 2 3 5)
(0 2 4 5)
(0 3 4 5)
(1 2 3 4)
(1 2 3 5)
(1 2 4 5)
(1 3 4 5)
(2 3 4 5)
