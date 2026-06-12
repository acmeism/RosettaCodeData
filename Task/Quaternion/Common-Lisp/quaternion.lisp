(defclass quaternion () ((a :accessor q-a :initarg :a :type real)
                         (b :accessor q-b :initarg :b :type real)
                         (c :accessor q-c :initarg :c :type real)
                         (d :accessor q-d :initarg :d :type real))
  (:default-initargs :a 0 :b 0 :c 0 :d 0))

(defun make-q (&optional (a 0) (b 0) (c 0) (d 0))
  (make-instance 'quaternion :a a :b b :c c :d d))

(defgeneric sum (x y))

(defmethod sum ((x quaternion) (y quaternion))
  (make-q  (+ (q-a x) (q-a y))
           (+ (q-b x) (q-b y))
           (+ (q-c x) (q-c y))
           (+ (q-d x) (q-d y))))

(defmethod sum ((x quaternion) (y real))
  (make-q  (+ (q-a x) y) (q-b x) (q-c x) (q-d x)))

(defmethod sum ((x real) (y quaternion))
  (make-q  (+ (q-a y) x) (q-b y) (q-c y) (q-d y)))

(defgeneric sub (x y))

(defmethod sub ((x quaternion) (y quaternion))
  (make-q  (- (q-a x) (q-a y))
           (- (q-b x) (q-b y))
           (- (q-c x) (q-c y))
           (- (q-d x) (q-d y))))

(defmethod sub ((x quaternion) (y real))
  (make-q  (- (q-a x) y)
           (q-b x)
           (q-c x)
           (q-d x)))

(defmethod sub ((x real) (y quaternion))
  (make-q  (- (q-a y) x)
           (q-b y)
           (q-c y)
           (q-d y)))

(defgeneric mul (x y))

(defmethod mul ((x quaternion) (y real))
  (make-q  (* (q-a x) y)
           (* (q-b x) y)
           (* (q-c x) y)
           (* (q-d x) y)))

(defmethod mul ((x real) (y quaternion))
  (make-q  (* (q-a y) x)
           (* (q-b y) x)
           (* (q-c y) x)
           (* (q-d y) x)))

(defmethod mul ((x quaternion) (y quaternion))
  (make-q  (- (* (q-a x) (q-a y)) (* (q-b x) (q-b y)) (* (q-c x) (q-c y)) (* (q-d x) (q-d y)))
           (- (+ (* (q-a x) (q-b y)) (* (q-b x) (q-a y)) (* (q-c x) (q-d y))) (* (q-d x) (q-c y)))
           (- (+ (* (q-a x) (q-c y)) (* (q-c x) (q-a y)) (* (q-d x) (q-b y))) (* (q-b x) (q-d y)))
           (- (+ (* (q-a x) (q-d y)) (* (q-b x) (q-c y)) (* (q-d x) (q-a y))) (* (q-c x) (q-b y)))))

(defmethod norm ((x quaternion))
  (+ (sqrt (q-a x)) (sqrt (q-b x)) (sqrt (q-c x)) (sqrt (q-d x))))

(defmethod print-object ((x quaternion) stream)
  (format stream "~@f~@fi~@fj~@fk" (q-a x) (q-b x) (q-c x) (q-d x)))

(defvar q (make-q 0 1 0 0))
(defvar q1 (make-q 0 0 1 0))
(defvar q2 (make-q 0 0 0 1))
(defvar r 7)
(format t "q+q1+q2 = ~a~&" (reduce #'sum (list q q1 q2)))
(format t "r*(q+q1+q2) = ~a~&" (mul r (reduce #'sum (list q q1 q2))))
(format t "q*q1*q2 = ~a~&" (reduce #'mul (list q q1 q2)))
(format t "q-q1-q2 = ~a~&" (reduce #'sub (list q q1 q2)))
