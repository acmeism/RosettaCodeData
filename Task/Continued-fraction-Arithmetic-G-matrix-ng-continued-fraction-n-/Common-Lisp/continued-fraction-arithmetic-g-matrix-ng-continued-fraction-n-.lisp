(defstruct cf-record
  terminated-p                    ; Are these all the terms there are?
  m                               ; How many terms are memoized so far?
  memo                            ; Where terms are memoized.
  gen)                            ; A thunk that generates terms.

(deftype continued-fraction 'cf-record)

(defun make-continued-fraction (gen)
  (make-cf-record :terminated-p nil
                  :m 0
                  :memo (make-array '(8))
                  :gen gen))

(defun cf-get-more-terms (cf needed)
  (loop with term
        for i from (cf-record-m cf) upto needed
        do (setf term (funcall (cf-record-gen cf)))
        unless term
          do (setf (cf-record-terminated-p cf) t)
        end
        while term do (setf (aref (cf-record-memo cf) i) term)
        finally (setf (cf-record-m cf) i)))

(defun cf-update (cf needed)
  (cond ((cf-record-terminated-p cf) (progn))
        ((<= needed (cf-record-m cf)) (progn))
        ((<= needed (array-dimension (cf-record-memo cf) 0))
         (cf-get-more-terms cf needed))
        (t ;; Provide twice the room that might be needed.
         (let* ((n1 (+ needed needed))
                (memo1 (make-array (list n1))))
           (loop for i from 0 upto (1- (cf-record-m cf))
                 do (setf (aref memo1 i)
                          (aref (cf-record-memo cf) i)))
           (setf (cf-record-memo cf) memo1)
           (cf-get-more-terms cf needed)))))

(defun continued-fraction-ref (cf i)
  (cf-update cf (1+ i))
  (and (< i (cf-record-m cf))
       (aref (cf-record-memo cf) i)))

(defun continued-fraction-to-thunk (cf)
  ;; Make a generator from a continued fraction.
  (let ((i 0))
    (lambda ()
      (let ((term (continued-fraction-ref cf i)))
        (setf i (1+ i))
        term))))

(defun continued-fraction-to-string (cf &optional (max-terms 20))
  (loop with sep = 0
        with accum = "["
        with term
        for i from 0 upto (1- max-terms)
        do (setf term (continued-fraction-ref cf i))
        if term
          do (let ((sep-str (case sep
                              ((0) "")
                              ((1) ";")
                              ((2) ","))))
               (setf sep (min (1+ sep) 2))
               (setf accum (concatenate 'string accum sep-str
                                        (format nil "~A" term))))
        else
          do (setf accum (concatenate 'string accum "]"))
             (return accum)
        end
        finally (setf accum (concatenate 'string accum ",...]"))
                (return accum)))

(defun r2cf (x)
  ;; This algorithm works directly with exact rationals, rather
  ;; than numerator and denominator separately.
  (let ((ratnum (coerce x 'rational))
        (terminated-p nil))
    (make-continued-fraction
     (lambda ()
       (and (not terminated-p)
            (multiple-value-bind (q r) (floor ratnum)
              (if (zerop r)
                  (setf terminated-p t)
                  (setf ratnum (/ r)))
              q))))))

(defstruct homographic-function a1 a b1 b)

(defun apply-homographic-function (hfunc cf)
  (let* ((gen (continued-fraction-to-thunk cf))
         (state (copy-homographic-function hfunc)))
    (make-continued-fraction
     (lambda ()
       (loop
         do (let ((a1 (homographic-function-a1 state))
                  (a (homographic-function-a state))
                  (b1 (homographic-function-b1 state))
                  (b (homographic-function-b state)))
              (cond ((and (zerop b1) (zerop b)) (return nil))
                    ((and (not (zerop b1)) (not (zerop b)))
                     (let ((q1 (nth-value 0 (floor a1 b1)))
                           (q (nth-value 0 (floor a b))))
                       (when (= q1 q)
                         (setf state (make-homographic-function
                                      :a1 b1
                                      :a b
                                      :b1 (- a1 (* b1 q))
                                      :b (- a (* b q))))
                         (return q)))))
              (let ((term (funcall gen)))
                (if term
                    (setf state
                          (make-homographic-function
                           :a1 (+ a (* a1 term))
                           :a a1
                           :b1 (+ b (* b1 term))
                           :b b1))
                    (progn
                      (setf (homographic-function-a state) a1)
                      (setf (homographic-function-b state)
                            b1))))))))))

(defun make-hf (a1 a b1 b)
  (make-homographic-function :a1 a1 :a a :b1 b1 :b b))

(defun apply-hf (hfunc cf)
  (apply-homographic-function hfunc cf))

(defun cf2string (cf)
  (continued-fraction-to-string cf))

(defvar cf+1/2 (make-hf 2 1 0 2))
(defvar cf/2 (make-hf 1 0 0 2))
(defvar cf/4 (make-hf 1 0 0 4))
(defvar 1/cf (make-hf 0 1 1 0))
(defvar 2+cf./4 (make-hf 1 2 0 4))
(defvar 1+cf./2 (make-hf 1 1 0 2))

(defvar cf_13/11 (r2cf 13/11))
(defvar cf_22/7 (r2cf 22/7))
(defvar cf_sqrt2
  (let ((next-term 1))
    (make-continued-fraction
     (lambda ()
       (let ((term next-term))
         (setf next-term 2)
         term)))))

(format t "13/11 => ~A~%" (cf2string cf_13/11))
(format t "22/7 => ~A~%" (cf2string cf_22/7))
(format t "sqrt(2) => ~A~%" (cf2string cf_sqrt2))
(format t  "13/11 + 1/2 => ~A~%"
        (cf2string (apply-hf cf+1/2 cf_13/11)))
(format t  "22/7 + 1/2 => ~A~%"
        (cf2string (apply-hf cf+1/2 cf_22/7)))
(format t  "(22/7)/4 => ~A~%"
        (cf2string (apply-hf cf/4 cf_22/7)))
(format t  "sqrt(2)/2 => ~A~%"
        (cf2string (apply-hf cf/2 cf_sqrt2)))
(format t  "1/sqrt(2) => ~A~%"
        (cf2string (apply-hf 1/cf cf_sqrt2)))
(format t  "(2 + sqrt(2))/4 => ~A~%"
        (cf2string (apply-hf 2+cf./4 cf_sqrt2)))
(format t  "(1 + 1/sqrt(2))/2 => ~A~%"
        (cf2string (apply-hf 1+cf./2 (apply-hf 1/cf cf_sqrt2))))
(format t  "sqrt(2)/4 + 1/2 => ~A~%"
        (cf2string (apply-hf cf+1/2 (apply-hf cf/4 cf_sqrt2))))
(format t  "(sqrt(2)/2)/2 + 1/2 => ~A~%"
        (cf2string (apply-hf cf+1/2
                            (apply-hf cf/2
                                     (apply-hf cf/2 cf_sqrt2)))))
(format t  "(1/sqrt(2))/2 + 1/2 => ~A~%"
        (cf2string (apply-hf cf+1/2
                            (apply-hf cf/2
                                     (apply-hf 1/cf cf_sqrt2)))))
