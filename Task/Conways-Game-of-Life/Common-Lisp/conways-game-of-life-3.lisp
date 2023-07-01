(defun moore-neighborhood (cell)
  (let ((r '(-1 0 1)))
    (mapcan
	 (lambda (delta-x)
	   (loop for delta-y in r
	      unless (and (= delta-x 0) (= delta-y 0))
	      collect (cons (+ (car cell) delta-x) (+ (cdr cell) delta-y))))
	 r)))

(defun frequencies (cells)
  (let ((h (make-hash-table :test #'equal)))
    (loop for c in cells
       if (gethash c h)
         do (incf (gethash c h))
       else
       do (setf (gethash c h) 1))
    h))

(defun life-step (cells)
  (let ((f (frequencies (mapcan #'moore-neighborhood cells))))
    (loop for k being the hash-keys in f
       when (or
	     (= (gethash k f) 3)
	     (and (= (gethash k f) 2) (member k cells :test #'equal)))
	 collect k)))

(defun print-world (live-cells &optional (world-size 10))
  (dotimes (y world-size)
    (dotimes (x world-size)
      (if (member (cons x y) live-cells :test #'equal)
	  (format t "X")
	  (format t ".")))
    (format t "~%")))

(defun run-life (world-size steps cells)
  (print-world cells world-size)
  (format t "~%")
  (when (< 0 steps)
    (run-life world-size (- steps 1) (life-step cells))))

(defparameter *blinker* '((1 . 2) (2 . 2) (3 . 2)))
(defparameter *glider* '((1 . 0) (2 . 1) (0 . 2) (1 . 2) (2 . 2)))
