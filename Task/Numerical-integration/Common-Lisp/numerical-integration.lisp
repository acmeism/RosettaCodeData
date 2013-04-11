(defun left-rectangle (f a b n &aux (d (/ (- b a) n)))
  (* d (loop for x from a below b by d summing (funcall f x))))

(defun right-rectangle (f a b n &aux (d (/ (- b a) n)))
  (* d (loop for x from b above a by d summing (funcall f x))))

(defun midpoint-rectangle (f a b n &aux (d (/ (- b a) n)))
  (* d (loop for x from (+ a (/ d 2)) below b by d summing (funcall f x))))

(defun trapezium (f a b n &aux (d (/ (- b a) n)))
  (* (/ d 2)
     (+ (funcall f a)
        (* 2 (loop for x from (+ a d) below b by d summing (funcall f x)))
        (funcall f b))))

(defun simpson (f a b n)
  (loop with h = (/ (- b a) n)
        with sum1 = (funcall f (+ a (/ h 2)))
        with sum2 = 0
        for i from 1 below n
        do (incf sum1 (funcall f (+ a (* h i) (/ h 2))))
        do (incf sum2 (funcall f (+ a (* h i))))
        finally (return (* (/ h 6)
                           (+ (funcall f a)
                              (funcall f b)
                              (* 4 sum1)
                              (* 2 sum2))))))
