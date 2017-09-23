(defstruct uncertain-number
  (value 0 :type number)
  (uncertainty 0 :type number))

(defmethod print-object ((n uncertain-number) stream)
  (format stream "~,2F ± ~,2F" (uncertain-number-value n) (uncertain-number-uncertainty n)))

(defun ~+ (n1 n2)
  (let* ((value1 (uncertain-number-value n1))
         (value2 (uncertain-number-value n2))
         (uncertainty1 (uncertain-number-uncertainty n1))
         (uncertainty2 (uncertain-number-uncertainty n2))
         (value (+ value1 value2))
         (uncertainty (sqrt (+ (* uncertainty1 uncertainty1)
                               (* uncertainty2 uncertainty2)))))
    (make-uncertain-number :value value :uncertainty uncertainty)))

(defun negate (n)
  (make-uncertain-number :value (- (uncertain-number-value n))
                         :uncertainty (uncertain-number-uncertainty n)))

(defun ~- (n1 n2)
  (~+ n1 (negate n2)))

(defun ~* (n1 n2)
  (let* ((value1 (uncertain-number-value n1))
         (value2 (uncertain-number-value n2))
         (uncertainty-ratio-1 (/ (uncertain-number-uncertainty n1) value1))
         (uncertainty-ratio-2 (/ (uncertain-number-uncertainty n2) value2))
         (value (* value1 value2))
         (uncertainty (sqrt (* value
                               value
                               (+ (* uncertainty-ratio-1 uncertainty-ratio-1)
                                  (* uncertainty-ratio-2 uncertainty-ratio-2))))))
    (make-uncertain-number :value value :uncertainty uncertainty)))

(defun inverse (n)
  (make-uncertain-number :value (/ (uncertain-number-value n))
                         :uncertainty (uncertain-number-uncertainty n)))

(defun ~/ (n1 n2)
  (~* n1 (inverse n2)))

(defun ~expt (base exp)
  (let* ((base-value (uncertain-number-value base))
         (uncertainty-ratio (/ (uncertain-number-uncertainty base) base-value))
         (value (expt base-value exp))
         (uncertainty (abs (* value exp uncertainty-ratio))))
    (make-uncertain-number :value value :uncertainty uncertainty)))

(defun solve ()
  (let* ((x1 (make-uncertain-number :value 100 :uncertainty 1.1))
         (y1 (make-uncertain-number :value  50 :uncertainty 1.2))
         (x2 (make-uncertain-number :value 200 :uncertainty 2.2))
         (y2 (make-uncertain-number :value 100 :uncertainty 2.3))
         (d  (~expt (~+ (~expt (~- x1 x2) 2) (~expt (~- y1 y2) 2))
                    1/2)))
    (format t "d = ~A~%" d)))
