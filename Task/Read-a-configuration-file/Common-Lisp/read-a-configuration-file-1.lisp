(ql:quickload :parser-combinators)

(defpackage :read-config
  (:use :cl :parser-combinators))

(in-package :read-config)

(defun trim-space (string)
  (string-trim '(#\space #\tab) string))

(defun any-but1? (except)
  (named-seq? (<- res (many1? (except? (item) except)))
              (coerce res 'string)))

(defun values? ()
  (named-seq? (<- values (sepby? (any-but1? #\,) #\,))
              (mapcar 'trim-space values)))

(defun key-values? ()
  (named-seq? (<- key (word?))
              (opt? (many? (whitespace?)))
              (opt? #\=)
              (<- values (values?))
              (cons key (or (if (cdr values) values (car values)) t))))

(defun parse-line (line)
  (setf line (trim-space line))
  (if (or (string= line "") (member (char line 0) '(#\# #\;)))
      :comment
      (parse-string* (key-values?) line)))

(defun parse-config (stream)
  (let ((hash (make-hash-table :test 'equal)))
    (loop for line = (read-line stream nil nil)
       while line
       do (let ((parsed (parse-line line)))
            (cond ((eq parsed :comment))
                  ((eq parsed nil) (error "config parser error: ~a" line))
                  (t (setf (gethash (car parsed) hash) (cdr parsed))))))
    hash))
