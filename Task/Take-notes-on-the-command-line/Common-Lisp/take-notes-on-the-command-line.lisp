(defparameter *notes* "NOTES.TXT")

(defun format-date-time (stream)
  (multiple-value-bind (second minute hour date month year) (get-decoded-time)
    (format stream "~D-~2,'0D-~2,'0D ~2,'0D:~2,'0D:~2,'0D"
            year month date hour minute second)))

(defun notes (args)
  (if args
      (with-open-file (s *notes* :direction :output
                                 :if-exists :append
                                 :if-does-not-exist :create)
        (format-date-time s)
        (format s "~&~A~{~A~^ ~}~%" #\Tab args))
      (with-open-file (s *notes* :if-does-not-exist nil)
        (when s
          (loop for line = (read-line s nil)
                while line
                do (write-line line))))))

(defun main ()
  (notes (uiop:command-line-arguments)))
