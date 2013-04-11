(defparameter *hof-con*
  (make-array '(2) :initial-contents '(1 1) :adjustable t
	      :element-type 'integer :fill-pointer 2))

(defparameter *hof-con-ratios*
  (make-array '(2) :initial-contents '(1.0 0.5) :adjustable t
	      :element-type 'single-float :fill-pointer 2))

(defun hof-con (n)
  (let ((l (length *hof-con*)))
    (if (<= n l) (aref *hof-con* (1- n))
	(extend-hof-con-sequence l n))))

(defun extend-hof-con-sequence (l n)
  (loop for i from l below n do
       (let* ((x (aref *hof-con* (1- i)))
	      (hc (+ (aref *hof-con* (1- x))
		     (aref *hof-con* (- i x)))))
	 (vector-push-extend hc *hof-con*)
	 (vector-push-extend (/ hc (+ i 1.0)) *hof-con-ratios*)))
  (aref *hof-con* (1- n)))

(defun max-in-array-range (arr id1 id2)
  (let ((m 0) (id 0))
    (loop for i from (1- id1) to (1- id2) do
	 (let ((n (aref arr i)))
	   (if (> n m) (setq m n id i))))
    (values m (1+ id))))

(defun maxima (po2)
  (hof-con (expt 2 po2))
  (loop for i from 1 below po2 do
       (let ((id1 (expt 2 i)) (id2 (expt 2 (1+ i))))
	 (multiple-value-bind (m id)
	     (max-in-array-range *hof-con-ratios* id1 id2)
	   (format t "Local maximum in [~A .. ~A]: ~A at n = ~A~%" id1 id2 m id)))))

(defun mallows (po2)
  (let ((n (expt 2 po2)))
    (hof-con n)
    (do ((i (1- n) (1- i)))
	((> (aref *hof-con-ratios* i) 0.55) (+ i 1)))))
