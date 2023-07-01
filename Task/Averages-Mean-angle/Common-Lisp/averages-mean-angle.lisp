(defun average (list)
  (/ (reduce #'+ list) (length list)))

(defun radians (angle)
  (* pi 1/180 angle))

(defun degrees (angle)
  (* (/ 180 pi) angle))

(defun mean-angle (angles)
  (let* ((angles (map 'list #'radians angles))
	 (cosines (map 'list #'cos angles))
	 (sines (map 'list #'sin angles)))
    (degrees (atan (average sines) (average cosines)))))

(loop for angles in '((350 10) (90 180 270 360) (10 20 30))
   do (format t "~&The mean angle of ~a is ~$°." angles (mean-angle angles)))

;; or using complex numbers (cis and phase)

(defun mean-angle-2 (angles)
    (degrees (phase (reduce #'+ angles :key (lambda (deg) (cis (radians deg)))))))
