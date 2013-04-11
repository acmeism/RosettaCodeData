(defun fs (f s) (mapcar f s))
(defun f1 (i) (* i 2))
(defun f2 (i) (expt i 2))

(defun partial (func &rest args1)
  (lambda (&rest args2) (apply func (append args1 args2))))
(defvar fsf1 (partial #'fs #'f1))
(defvar fsf2 (partial #'fs #'f2))

(dolist (seq '((0 1 2 3) (2 4 6 8)))
  (format t "~%seq: ~A~%  fsf1 seq: ~A~%  fsf2 seq: ~A"
	  seq (funcall fsf1 seq) (funcall fsf2 seq)))
