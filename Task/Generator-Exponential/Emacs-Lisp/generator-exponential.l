(require 'generator)
(setq lexical-binding t)

(iter-defun exp-gen (pow)
  (let ((i -1))
    (while
      (setq i (1+ i))
      (iter-yield (expt i pow)))))

(iter-defun flt-gen ()
  (let* ((g (exp-gen 2))
	 (f (exp-gen 3))
	 (i (iter-next g))
	 (j (iter-next f)))
    (while
      (setq i (iter-next g))
      (while (> i j)
	(setq j (iter-next f)))
      (unless (= i j)
	(iter-yield i)))))
	

(let ((g (flt-gen))
      (o 'nil))
  (dotimes (i 29)
    (setq o (iter-next g))
    (when (>= i 20)
      (print o))))
