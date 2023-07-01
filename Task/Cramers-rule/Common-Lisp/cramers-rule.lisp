(defun minor (m col)
  (loop with dim = (1- (array-dimension m 0))
        with result = (make-array (list dim dim))
        for i from 1 to dim
        for r = (1- i)
        do (loop with c = 0
                 for j to dim
                 when (/= j col)
                   do (setf (aref result r c) (aref m i j))
                      (incf c))
        finally (return result)))

(defun det (m)
  (assert (= (array-rank m) 2))
  (assert (= (array-dimension m 0) (array-dimension m 1)))
  (let ((dim (array-dimension m 0)))
    (if (= dim 1)
        (aref m 0 0)
        (loop for col below dim
              for sign = 1 then (- sign)
              sum (* sign (aref m 0 col) (det (minor m col)))))))

(defun replace-column (m col values)
  (let* ((dim (array-dimension m 0))
         (result (make-array (list dim dim))))
    (dotimes (r dim result)
      (dotimes (c dim)
        (setf (aref result r c)
              (if (= c col) (aref values r) (aref m r c)))))))

(defun solve (m v)
  (loop with dim = (array-dimension m 0)
        with det = (det m)
        for col below dim
        collect (/ (det (replace-column m col v)) det)))

(solve #2A((2 -1  5  1)
           (3  2  2 -6)
           (1  3  3 -1)
           (5 -2 -3  3))
       #(-3 -32 -47 49))
