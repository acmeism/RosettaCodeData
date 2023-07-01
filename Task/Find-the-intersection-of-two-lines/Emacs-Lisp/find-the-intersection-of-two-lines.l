;; y = a*x + b
(let ()
  (defun line-prop (p1 p2)
    (let* ((prop-a (/ (- (plist-get p2 'y) (plist-get p1 'y))
		      (- (plist-get p2 'x) (plist-get p1 'x))))
	   (prop-b (- (plist-get p1 'y) (* prop-a (plist-get p1 'x)))))

      (list 'a prop-a 'b prop-b) ) )

  (defun calculate-intersection (line1 line2)
    (if (= (plist-get line1 'a) (plist-get line2 'a))
	(progn (error "The two lines don't have any intersection.") nil)
      (progn
	(let (int-x int-y)
	  (setq int-x (/ (- (plist-get line2 'b) (plist-get line1 'b))
			 (- (plist-get line1 'a) (plist-get line2 'a))))
	  (setq int-y (+ (* (plist-get line1 'a) int-x) (plist-get line1 'b)))
	  (list 'x int-x 'y int-y) ) ) ) )

  (let ((p1 '(x 4.0 y 0.0)) (p2 '(x 6.0 y 10.0))
	(p3 '(x 0.0 y 3.0)) (p4 '(x 10.0 y 7.0)))
    (let ((line1 (line-prop p1 p2))
	  (line2 (line-prop p3 p4)))
      (message "%s" (calculate-intersection line1 line2)) ) )

  )
