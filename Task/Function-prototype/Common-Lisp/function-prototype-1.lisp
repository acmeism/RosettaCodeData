;; An empty lambda list () takes 0 parameters.
(defun 0args ()
  (format t "Called 0args~%"))

;; This lambda list (a b) takes 2 parameters.
(defun 2args (a b)
  (format t "Called 2args with ~A and ~A~%" a b))

;; Local variables from lambda lists may have declarations.
;; This function takes 2 arguments, which must be integers.
(defun 2ints (i j)
  (declare (type integer i j))
  (/ (+ i j) 2))
