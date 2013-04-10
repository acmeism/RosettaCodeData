(use-package :ltk)

(defparameter *message* "Hello World! ")
(defparameter *direction* :left)
(defun animate (label)
  (let* ((n (length *message*))
         (i (if (eq *direction* :left) 0 (1- n)))
         (c (char *message* i)))
    (if (eq *direction* :left)
        (setq *message* (concatenate 'string
				     (subseq *message* 1 n)
				     (list c)))
	(setq *message* (concatenate 'string (list c)
				     (subseq *message* 0 (1- n)))))
    (setf (ltk:text label) *message*)
    (ltk:after 125 (lambda () (animate label)))))

(defun basic-animation ()
  (ltk:with-ltk ()
      (let* ((label (make-instance 'label
                                   :font "Courier 14")))
        (setf (text label) *message*)
        (ltk:bind label "<Button-1>"
                  (lambda (event)
                    (declare (ignore event))
                    (cond
                     ((eq *direction* :left) (setq *direction* :right))
                     ((eq *direction* :right) (setq *direction* :left)))))
        (ltk:pack label)
        (animate label)
        (ltk:mainloop))))

(basic-animation)
