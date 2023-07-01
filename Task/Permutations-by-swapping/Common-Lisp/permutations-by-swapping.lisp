(defstruct (directed-number (:conc-name dn-))
  (number nil :type integer)
  (direction nil :type (member :left :right)))

(defmethod print-object ((dn directed-number) stream)
  (ecase (dn-direction dn)
    (:left  (format stream "<~D" (dn-number dn)))
    (:right (format stream "~D>" (dn-number dn)))))

(defun dn> (dn1 dn2)
  (declare (directed-number dn1 dn2))
  (> (dn-number dn1) (dn-number dn2)))

(defun dn-reverse-direction (dn)
  (declare (directed-number dn))
  (setf (dn-direction dn) (ecase (dn-direction dn)
                            (:left  :right)
                            (:right :left))))

(defun make-directed-numbers-upto (upto)
  (let ((numbers (make-array upto :element-type 'integer)))
    (dotimes (n upto numbers)
      (setf (aref numbers n) (make-directed-number :number (1+ n) :direction :left)))))

(defun max-mobile-pos (numbers)
  (declare ((vector directed-number) numbers))
  (loop with pos-limit = (1- (length numbers))
        with max-value and max-pos
        for num across numbers
        for pos from 0
        do (ecase (dn-direction num)
             (:left  (when (and (plusp pos) (dn> num (aref numbers (1- pos)))
                                (or (null max-value) (dn> num max-value)))
                       (setf max-value num
                             max-pos   pos)))
             (:right (when (and (< pos pos-limit) (dn> num (aref numbers (1+ pos)))
                                (or (null max-value) (dn> num max-value)))
                       (setf max-value num
                             max-pos   pos))))
        finally (return max-pos)))

(defun permutations (upto)
  (loop with numbers = (make-directed-numbers-upto upto)
        for max-mobile-pos = (max-mobile-pos numbers)
        for sign = 1 then (- sign)
        do (format t "~A sign: ~:[~;+~]~D~%" numbers (plusp sign) sign)
        while max-mobile-pos
        do (let ((max-mobile-number (aref numbers max-mobile-pos)))
             (ecase (dn-direction max-mobile-number)
               (:left  (rotatef (aref numbers (1- max-mobile-pos))
                                (aref numbers max-mobile-pos)))
               (:right (rotatef (aref numbers max-mobile-pos)
                                (aref numbers (1+ max-mobile-pos)))))
             (loop for n across numbers
                   when (dn> n max-mobile-number)
                     do (dn-reverse-direction n)))))

(permutations 3)
(permutations 4)
