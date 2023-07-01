;; Computes the initial guess for the root i of a n-order Legendre polynomial.
(defun guess (n i)
  (cos (* pi
          (/ (- i 0.25d0)
             (+ n 0.5d0)))))

;; Computes and evaluates the n-order Legendre polynomial at the point x.
(defun legpoly (n x)
  (let ((pa 1.0d0)
        (pb x)
        (pn))
    (cond ((= n 0) pa)
          ((= n 1) pb)
          (t (loop for i from 2 to n do
                  (setf pn (- (* (/ (- (* 2 i) 1) i) x pb)
                              (* (/ (- i 1) i) pa)))
                  (setf pa pb)
                  (setf pb pn)
                  finally (return pn))))))

;; Computes and evaluates the derivative of an n-order Legendre polynomial at point x.
(defun legdiff (n x)
  (* (/ n (- (* x x) 1))
     (- (* x (legpoly n x))
        (legpoly (- n 1) x))))

;; Computes the n nodes for an n-point quadrature rule. (i.e. n roots of a n-order polynomial)
(defun nodes (n)
  (let ((x (make-array n :initial-element 0.0d0)))
    (loop for i from 0 to (- n 1) do
         (let ((val (guess n (+ i 1))) ;Nullstellen-Schätzwert.
               (itermax 5))
           (dotimes (j itermax)
             (setf val (- val
                          (/ (legpoly n val)
                             (legdiff n val)))))
           (setf (aref x i) val)))
    x))

;; Computes the weight for an n-order polynomial at the point (node) x.
(defun legwts (n x)
  (/ 2
     (* (- 1 (* x x))
        (expt (legdiff n x) 2))))

;; Takes a array of nodes x and computes an array of corresponding weights w.
(defun weights (x)
  (let* ((n (car (array-dimensions x)))
         (w (make-array n :initial-element 0.0d0)))
    (loop for i from 0 to (- n 1) do
         (setf (aref w i) (legwts n (aref x i))))
    w))

;; Integrates a function f with a n-point Gauss-Legendre quadrature rule over the interval [a,b].
(defun int (f n a b)
  (let* ((x (nodes n))
         (w (weights x)))
    (* (/ (- b a) 2.0d0)
       (loop for i from 0 to (- n 1)
          sum (* (aref w i)
                 (funcall f (+ (* (/ (- b a) 2.0d0)
                                  (aref x i))
                               (/ (+ a b) 2.0d0))))))))
