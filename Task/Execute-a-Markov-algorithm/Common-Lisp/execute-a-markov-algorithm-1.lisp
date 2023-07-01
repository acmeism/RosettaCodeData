;;; Keeps track of all our rules
(defclass markov ()
  ((rules :initarg :rules :initform nil :accessor rules)))

;;; Definition of a rule
(defclass rule ()
  ((pattern :initarg :pattern :accessor pattern)
   (replacement :initarg :replacement :accessor replacement)
   (terminal :initform nil :initarg :terminal :accessor terminal)))

;;; Parse a rule with this regular expression
(defparameter *rex->* (compile-re "^(.+)(?: |\\t)->(?: |\\t)(\\.?)(.*)$"))

;;; Create a rule and add it to the markov object
(defmethod update-markov ((mkv markov) lhs terminating rhs)
  (setf (rules mkv) (cons
                     (make-instance 'rule :pattern lhs :replacement rhs :terminal terminating)
                     (rules mkv))))

;;; Parse a line and add it to the markov object
(defmethod parse-line ((mkv markov) line)
  (let ((trimmed (string-trim #(#\Space #\Tab) line)))
    (if (not (or
              (eql #\# (aref trimmed 0))
              (equal "" trimmed)))
        (let ((vals (multiple-value-list (match-re *rex->* line))))
          (if (not (car vals))
              (progn
                (format t "syntax error in ~A" line)
                (throw 'fail t)))
          (update-markov mkv (nth 2 vals) (equal "." (nth 3 vals)) (nth 4 vals))))))

;;; Make a markov object from the string of rules
(defun make-markov (rules-text)
  (catch 'fail
         (let ((mkv (make-instance 'markov)))
           (with-input-from-string (s rules-text)
             (loop for line = (read-line s nil)
                 while line do
                   (parse-line mkv line)))
           (setf (rules mkv) (reverse (rules mkv)))
           mkv)))

;;; Given a rule and bounds where it applies, apply it to the input text
(defun adjust (rule-info text)
  (let* ((rule (car rule-info))
         (index-start (cadr rule-info))
         (index-end (caddr rule-info))
         (prefix (subseq text 0 index-start))
         (suffix (subseq text index-end))
         (replace (replacement rule)))
    (concatenate 'string prefix replace suffix)))

;;; Get the next applicable rule or nil if none
(defmethod get-rule ((markov markov) text)
  (dolist (rule (rules markov) nil)
    (let ((index (search (pattern rule) text)))
      (if index
          (return (list rule index (+ index (length (pattern rule)))))))))

;;; Interpret text using a markov object
(defmethod interpret ((markov markov) text)
  (let ((rule-info (get-rule markov text))
        (ret text))
    (loop (if (not rule-info) (return ret))
          (setf ret (adjust rule-info ret))
          (if (terminal (car rule-info)) (return ret))
          (setf rule-info (get-rule markov ret)))))
