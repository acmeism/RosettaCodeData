(defun tri-not (x) (- 1 x))
(defun tri-and (&rest x) (apply #'* x))
(defun tri-or (&rest x) (tri-not (apply #'* (mapcar #'tri-not x))))
(defun tri-eq (x y) (+ (tri-and x y) (tri-and (- 1 x) (- 1 y))))
(defun tri-imply (x y) (tri-or (tri-not x) y))

(defun tri-test (x) (< (random 1e0) x))
(defun tri-string (x) (if (= x 1) "T" (if (= x 0) "F" "?")))

;; to say (tri-if (condition) (yes) (no))
(defmacro tri-if (tri ifcase &optional elsecase)
  `(if (tri-test ,tri) ,ifcase ,elsecase))

(defun print-table (func header)
  (let ((vals '(1 .5 0)))
    (format t "~%~a:~%" header)
    (format t "    ~{~a ~^~}~%---------~%" (mapcar #'tri-string vals))
    (loop for row in vals do
	  (format t "~a | " (tri-string row))
	  (loop for col in vals do
		(format t "~a " (tri-string (funcall func row col))))
	  (write-line ""))))

(write-line "NOT:")
(loop for row in '(1 .5 0) do
      (format t "~a | ~a~%" (tri-string row) (tri-string (tri-not row))))

(print-table #'tri-and   "AND")
(print-table #'tri-or    "OR")
(print-table #'tri-imply "IMPLY")
(print-table #'tri-eq    "EQUAL")
