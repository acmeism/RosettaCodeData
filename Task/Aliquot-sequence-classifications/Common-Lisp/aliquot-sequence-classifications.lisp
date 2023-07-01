(defparameter *nlimit* 16)
(defparameter *klimit* (expt 2 47))
(defparameter *asht* (make-hash-table))
(load "proper-divisors")

(defun ht-insert (v n)
  (setf (gethash v *asht*) n))

(defun ht-find (v n)
   (let ((nprev (gethash v *asht*)))
    (if nprev (- n nprev) nil)))

(defun ht-list ()
  (defun sort-keys (&optional (res '()))
    (maphash #'(lambda (k v) (push (cons k v) res)) *asht*)
    (sort (copy-list res) #'< :key (lambda (p) (cdr p))))
  (let ((sorted (sort-keys)))
    (dotimes (i (length sorted)) (format t "~A " (car (nth i sorted))))))

(defun aliquot-generator (K1)
  "integer->function::fn to generate aliquot sequence"
  (let ((Kn K1))
    #'(lambda () (setf Kn (reduce #'+ (proper-divisors-recursive Kn) :initial-value 0)))))

(defun aliquot (K1)
  "integer->symbol|nil::classify aliquot sequence"
  (defun aliquot-sym (Kn n)
    (let* ((period (ht-find Kn n))
           (sym (if period
                    (cond ; period event
                     ((= Kn K1)
                      (case period (1 'PERF) (2 'AMIC) (otherwise 'SOCI)))
                     ((= period 1) 'ASPI)
                     (t 'CYCL))
                    (cond ; else check for limit event
                     ((= Kn 0) 'TERM)
                     ((> Kn *klimit*) 'TLIM)
                     ((= n *nlimit*) 'NLIM)
                     (t nil)))))
      ;; if period event store the period, if no event insert the value
      (if sym (when period (setf (symbol-plist sym) (list period)))
          (ht-insert Kn n))
      sym))

  (defun aliquot-str (sym &optional (period 0))
    (case sym (TERM "terminating") (PERF "perfect") (AMIC "amicable") (ASPI "aspiring")
      (SOCI (format nil "sociable (period ~A)" (car (symbol-plist sym))))
      (CYCL (format nil "cyclic (period ~A)" (car (symbol-plist sym))))
      (NLIM (format nil "non-terminating (no classification before added term limit of ~A)" *nlimit*))
      (TLIM (format nil "non-terminating (term threshold of ~A exceeded)" *klimit*))
      (otherwise "unknown")))

  (clrhash *asht*)
  (let ((fgen (aliquot-generator K1)))
    (setf (symbol-function 'aliseq) #'(lambda () (funcall fgen))))
  (ht-insert K1 0)
  (do* ((n 1 (1+ n))
        (Kn (aliseq) (aliseq))
        (alisym (aliquot-sym Kn n) (aliquot-sym Kn n)))
       (alisym (format t "~A:" (aliquot-str alisym)) (ht-list) (format t "~A~%" Kn) alisym)))

(defun main ()
  (princ "The last item in each sequence triggers classification.") (terpri)
  (dotimes (k 10)
    (aliquot (+ k 1)))
  (dolist (k '(11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080))
    (aliquot k)))
