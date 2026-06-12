(defstruct (cf (:conc-name %%cf-)
               (:constructor make-cf (generator)))
  "continued fraction"
  (generator            nil :type function)
  (terminated-p         nil :type boolean)
  (memo  (make-array '(32)) :type (array integer))
  (memo-count             0 :type fixnum))

(defstruct (ng8 (:constructor ng8 (a12 a1 a2 a
                                   b12 b1 b2 b)))
  "coefficients of a bihomographic function"
  (a12 0 :type integer)
  (a1  0 :type integer)
  (a2  0 :type integer)
  (a   0 :type integer)
  (b12 0 :type integer)
  (b1  0 :type integer)
  (b2  0 :type integer)
  (b   0 :type integer))

(defun cf-ref (cf i)
  "Return the ith term, or nil if there is none."
  (declare (cf cf) (fixnum i))
  (defun get-more-terms (needed)
    (declare (fixnum needed))
    (loop while (not (%%cf-terminated-p cf))
          while (< (%%cf-memo-count cf) needed)
          do (let ((term (funcall (%%cf-generator cf))))
               (cond (term (let ((memo (%%cf-memo cf))
                                 (m (%%cf-memo-count cf)))
                             (setf (aref memo m) term)
                             (setf (%%cf-memo-count cf) (1+ m))))
                     (t (setf (%%cf-terminated-p cf) t))))))
  (defun update (needed)
    (declare (fixnum needed))
    (cond ((%%cf-terminated-p cf) (progn))
          ((<= needed (%%cf-memo-count cf)) (progn))
          ((<= needed (array-dimension (%%cf-memo cf) 0))
           (get-more-terms needed))
          (t (let* ((n1 (+ needed needed))
                    (memo1 (make-array (list n1))))
               (loop for i from 0 upto (1- (%%cf-memo-count cf))
                     do (setf (aref memo1 i) (aref (%%cf-memo cf) i)))
               (setf (%%cf-memo cf) memo1)
               (get-more-terms needed)))))
  (update (1+ i))
  (the (or integer null) (and (< i (%%cf-memo-count cf))
                              (aref (%%cf-memo cf) i))))

(defparameter *cf-max-terms* 20
  "Default term-count limit for cf->string.")

(defun cf->string (cf &optional (max-terms *cf-max-terms*))
  "Make a readable string from a continued fraction."
  (declare (cf cf))
  (loop with i = 0
        with s = "["
        do (let ((term (cf-ref cf i)))
             (cond ((not term)
                    (return (concatenate 'string s "]")))
                   ((= i max-terms)
                    (return (concatenate 'string s ",...]")))
                   (t (let ((separator (case i
                                         ((0) "")
                                         ((1) ";")
                                         (t ",")))
                            (term-str (format nil "~A" term)))
                        (setf i (1+ i))
                        (setf s (concatenate 'string s separator
                                             term-str))))))))

(defun integer->cf (num)
  "Transform an integer to a continued fraction."
  (declare (integer num))
  (let ((terminated-p nil))
    (declare (boolean terminated-p))
    (make-cf #'(lambda ()
                 (and (not terminated-p)
                      (progn (setf terminated-p t)
                             num))))))

(defun ratio->cf (num)
  "Transform a ratio to a continued fraction."
  (declare (ratio num))
  (let ((n (the integer (numerator num)))
        (d (the integer (denominator num))))
    (make-cf #'(lambda ()
                 (and (not (zerop d))
                      (multiple-value-bind (q r) (floor n d)
                        (setf n d)
                        (setf d r)
                        q))))))

;; Thresholds chosen merely for demonstration.
(defparameter number-that-is-too-big (expt 2 512))
(defparameter practically-infinite (expt 2 64))

(defun num-too-big-p (num)
  (declare (integer num))
  (>= (abs num) (abs number-that-is-too-big)))

(defun ng8-too-big-p (ng)
  (declare (ng8 ng))
  (or (num-too-big-p (ng8-a12 ng))
      (num-too-big-p (ng8-a1 ng))
      (num-too-big-p (ng8-a2 ng))
      (num-too-big-p (ng8-a ng))
      (num-too-big-p (ng8-b12 ng))
      (num-too-big-p (ng8-b1 ng))
      (num-too-big-p (ng8-b2 ng))
      (num-too-big-p (ng8-b ng))))

(defun treat-as-infinite-p (term)
  (declare (integer term))
  (>= (abs term) (abs practically-infinite)))

(defun quotient (u v)
  (declare (integer u v))
  (if (zerop v)
      (list nil nil)
      (multiple-value-list (floor u v))))

(defmacro absorb-x-term (ng xsource)
  `(let ((a12 (ng8-a12 ,ng))
         (a1 (ng8-a1 ,ng))
         (a2 (ng8-a2 ,ng))
         (a (ng8-a ,ng))
         (b12 (ng8-b12 ,ng))
         (b1 (ng8-b1 ,ng))
         (b2 (ng8-b2 ,ng))
         (b (ng8-b ,ng))
         (term (funcall ,xsource)))
     (if term
         (let ((ng^ (ng8 (+ a2 (* a12 term))
                         (+ a  (* a1  term)) a12 a1
                         (+ b2 (* b12 term))
                         (+ b  (* b1  term)) b12 b1)))
           (if (not (ng8-too-big-p ng^))
               (setf ,ng ng^)
               (progn (setf ,ng (ng8 a12 a1 a12 a1 b12 b1 b12 b1))
                      ;; Replace the x source with one that never
                      ;; returns a term.
                      (setf ,xsource #'no-terms-thunk))))
         (setf ,ng (ng8 a12 a1 a12 a1 b12 b1 b12 b1)))))

(defmacro absorb-y-term (ng ysource)
  `(let ((a12 (ng8-a12 ,ng))
         (a1 (ng8-a1 ,ng))
         (a2 (ng8-a2 ,ng))
         (a (ng8-a ,ng))
         (b12 (ng8-b12 ,ng))
         (b1 (ng8-b1 ,ng))
         (b2 (ng8-b2 ,ng))
         (b (ng8-b ,ng))
         (term (funcall ,ysource)))
     (if term
         (let ((ng^ (ng8 (+ a1 (* a12 term)) a12
                         (+ a  (* a2  term)) a2
                         (+ b1 (* b12 term)) b12
                         (+ b  (* b2  term)) b2)))
           (if (not (ng8-too-big-p ng^))
               (setf ,ng ng^)
               (progn (setf ,ng (ng8 a12 a12 a2 a2 b12 b12 b2 b2))
                      ;; Replace the y source with one that never
                      ;; returns a term.
                      (setf ysource #'no-terms-thunk))))
         (setf ,ng (ng8 a12 a12 a2 a2 b12 b12 b2 b2)))))

(defun cf->thunk (cf)
  (let ((i 0))
    #'(lambda ()
        (let ((term (cf-ref cf i)))
          (setf i (1+ i))
          term))))

(defun no-terms-thunk ()
  nil)

(defun apply-ng8 (ng8 x y)
  (declare (ng8 ng8))
  (let ((ng ng8)
        (xsource (cf->thunk x))
        (ysource (cf->thunk y)))
    (flet
        ((main ()
           (loop
             with absorb

             for bzero = (zerop (ng8-b ng))
             for b1zero = (zerop (ng8-b1 ng))
             for b2zero = (zerop (ng8-b2 ng))
             for b12zero = (zerop (ng8-b12 ng))

             do (multiple-value-bind (q r q1 r1 q2 r2 q12 r12)
                    (values-list
                     `(,@(quotient (ng8-a ng) (ng8-b ng))
                       ,@(quotient (ng8-a1 ng) (ng8-b1 ng))
                       ,@(quotient (ng8-a2 ng) (ng8-b2 ng))
                       ,@(quotient (ng8-a12 ng) (ng8-b12 ng))))
                  (cond
                    ((and bzero b1zero b2zero b12zero) (return nil))
                    ((and bzero b2zero) (setf absorb 'x))
                    ((or bzero b2zero) (setf absorb 'y))
                    (b1zero (setf absorb 'x))
                    ((and (not b12zero) (= q q1 q2 q12))
                     ;;
                     ;; Output a term.
                     ;;
                     (setf ng (ng8 (ng8-b12 ng) (ng8-b1 ng)
                                   (ng8-b2 ng) (ng8-b ng)
                                   r12 r1 r2 r))
                     (return (and (not (treat-as-infinite-p q)) q)))
                    (t
                     ;;
                     ;; Rather than compare fractions, we will put the
                     ;; numerators over a common denominator of
                     ;; b*b1*b2, and then compare the new numerators.
                     ;;
                     (let ((n  (* (ng8-a ng) (ng8-b1 ng) (ng8-b2 ng)))
                           (n1 (* (ng8-a1 ng) (ng8-b ng) (ng8-b2 ng)))
                           (n2 (* (ng8-a2 ng) (ng8-b ng) (ng8-b1 ng))))
                       (if (> (abs (- n1 n)) (abs (- n2 n)))
                           (setf absorb 'x)
                           (setf absorb 'y))))))

             when (eq absorb 'x)
               do (absorb-x-term ng xsource)

             when (eq absorb 'y)
               do (absorb-y-term ng ysource))))

      (make-cf #'main))))

(defun show (expression cf &optional (note ""))
  (format t "~A =>  ~A~A~%" expression (cf->string cf) note))

(defvar golden-ratio (make-cf #'(lambda () 1)))
(defvar silver-ratio (make-cf #'(lambda () 2)))
(defvar sqrt2 (make-cf (let ((next-term 1))
                  #'(lambda ()
                      (let ((term next-term))
                        (setf next-term 2)
                        term)))))
(defvar frac13/11 (ratio->cf 13/11))
(defvar frac22/7 (ratio->cf 22/7))
(defvar one (integer->cf 1))
(defvar two (integer->cf 2))
(defvar three (integer->cf 3))
(defvar four (integer->cf 4))

(defun cf+ (x y) (apply-ng8 (ng8 0 1 1 0 0 0 0 1) x y))
(defun cf- (x y) (apply-ng8 (ng8 0 1 -1 0 0 0 0 1) x y))
(defun cf* (x y) (apply-ng8 (ng8 1 0 0 0 0 0 0 1) x y))
(defun cf/ (x y) (apply-ng8 (ng8 0 1 0 0 0 0 1 0) x y))

(show "      golden ratio" golden-ratio)
(show "      silver ratio" silver-ratio)
(show "           sqrt(2)" sqrt2)
(show "             13/11" frac13/11)
(show "              22/7" frac22/7)
(show "                 1" one)
(show "                 2" two)
(show "                 3" three)
(show "                 4" four)
(show " (1 + 1/sqrt(2))/2" (cf/ silver-ratio
                                (cf* sqrt2 (cf* sqrt2 sqrt2)))
      "  method 1")
(show " (1 + 1/sqrt(2))/2" (apply-ng8 (ng8 1 0 0 1 0 0 0 8)
                                      silver-ratio
                                      silver-ratio)
      "  method 2")
(show " (1 + 1/sqrt(2))/2" (cf/ (cf/ (cf/ silver-ratio sqrt2)
                                     sqrt2)
                                sqrt2)
      "  method 3")
(show " sqrt(2) + sqrt(2)" (cf+ sqrt2 sqrt2))
(show " sqrt(2) - sqrt(2)" (cf- sqrt2 sqrt2))
(show " sqrt(2) * sqrt(2)" (cf* sqrt2 sqrt2))
(show " sqrt(2) / sqrt(2)" (cf/ sqrt2 sqrt2))
