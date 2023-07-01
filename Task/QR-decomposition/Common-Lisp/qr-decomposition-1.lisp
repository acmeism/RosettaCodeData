(defun sign (x)
  (if (zerop x)
      x
      (/ x (abs x))))

(defun norm (x)
  (let ((len (car (array-dimensions x))))
    (sqrt (loop for i from 0 to (1- len) sum (expt (aref x i 0) 2)))))

(defun make-unit-vector (dim)
  (let ((vec (make-array `(,dim ,1) :initial-element 0.0d0)))
    (setf (aref vec 0 0) 1.0d0)
    vec))

;; Return a nxn identity matrix.
(defun eye (n)
  (let ((I (make-array `(,n ,n) :initial-element 0)))
    (loop for j from 0 to (- n 1) do
          (setf (aref I j j) 1))
    I))

(defun array-range (A ma mb na nb)
  (let* ((mm (1+ (- mb ma)))
         (nn (1+ (- nb na)))
         (B (make-array `(,mm ,nn) :initial-element 0.0d0)))

    (loop for i from 0 to (1- mm) do
         (loop for j from 0 to (1- nn) do
              (setf (aref B i j)
                    (aref A (+ ma i) (+ na j)))))
    B))

(defun rows (A) (car  (array-dimensions A)))
(defun cols (A) (cadr (array-dimensions A)))
(defun mcol (A n) (array-range A 0 (1- (rows A)) n n))
(defun mrow (A n) (array-range A n n 0 (1- (cols A))))

(defun array-embed (A B row col)
  (let* ((ma (rows A))
         (na (cols A))
         (mb (rows B))
         (nb (cols B))
         (C  (make-array `(,ma ,na) :initial-element 0.0d0)))

    (loop for i from 0 to (1- ma) do
         (loop for j from 0 to (1- na) do
              (setf (aref C i j) (aref A i j))))

    (loop for i from 0 to (1- mb) do
         (loop for j from 0 to (1- nb) do
              (setf (aref C (+ row i) (+ col j))
                    (aref B i j))))

    C))
