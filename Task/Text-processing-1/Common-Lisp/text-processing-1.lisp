(defvar *invalid-count*)
(defvar *max-invalid*)
(defvar *max-invalid-date*)
(defvar *total-sum*)
(defvar *total-valid*)

(defun read-flag (stream date)
  (let ((flag (read stream)))
    (if (plusp flag)
        (setf *invalid-count* 0)
        (when (< *max-invalid* (incf *invalid-count*))
          (setf *max-invalid* *invalid-count*)
          (setf *max-invalid-date* date)))
    flag))

(defun parse-line (line)
  (with-input-from-string (s line)
    (let ((date (make-string 10)))
      (read-sequence date s)
      (cons date (loop repeat 24 collect (list (read s)
                                               (read-flag s date)))))))

(defun analyze-line (line)
  (destructuring-bind (date &rest rest) line
    (let* ((valid (remove-if-not #'plusp rest :key #'second))
           (n (length valid))
           (sum (apply #'+ (mapcar #'rationalize (mapcar #'first valid))))
           (avg (if valid (/ sum n) 0)))
      (incf *total-valid* n)
      (incf *total-sum* sum)
      (format t "Line: ~a  Reject: ~2d  Accept: ~2d  ~
                 Line_tot: ~8,3f  Line_avg: ~7,3f~%"
              date (- 24 n) n sum avg))))

(defun process (pathname)
  (let ((*invalid-count* 0) (*max-invalid* 0) *max-invalid-date*
        (*total-sum* 0) (*total-valid* 0))
    (with-open-file (f pathname)
      (loop for line = (read-line f nil nil)
            while line
            do (analyze-line (parse-line line))))
    (format t "~%File     = ~a" pathname)
    (format t "~&Total    = ~f" *total-sum*)
    (format t "~&Readings = ~a" *total-valid*)
    (format t "~&Average  = ~10,3f~%" (/ *total-sum* *total-valid*))
    (format t "~%Maximum run(s) of ~a consecutive false readings ends at ~
               line starting with date(s): ~a~%"
            *max-invalid* *max-invalid-date*)))
