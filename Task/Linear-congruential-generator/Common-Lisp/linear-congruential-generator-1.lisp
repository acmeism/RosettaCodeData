(defun make-rng (&key (seed 0) (mode nil))
  "returns an RNG according to :seed and :mode keywords
  default mode: bsd
  default seed: 0 (should be 1 actually)"
  (if (eql mode 'ms)
    #'(lambda ()
	(ash (setf seed (mod (+ (* 214013 seed) 2531011) (expt 2 31))) -16))
    #'(lambda () (setf seed (mod (+ (* seed 1103515245) 12345) (expt 2 31))))))

(let ((rng (make-rng)))
      (dotimes (x 10) (format t "BSD: ~d~%" (funcall rng))))

(let ((rng (make-rng :mode 'ms :seed 1)))
      (dotimes (x 10) (format t "MS: ~d~%" (funcall rng))))
