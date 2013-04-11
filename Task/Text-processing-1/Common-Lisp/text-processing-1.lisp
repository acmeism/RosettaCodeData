(defstruct (measurement
	     (:conc-name "MEASUREMENT-")
	     (:constructor make-measurement (counter line date flag value)))
  (counter 0 :type (integer 0))
  (line 0 :type (integer 0))
  (date nil :type symbol)
  (flag 0 :type integer)
  (value 0 :type real))

(defun measurement-valid-p (m)
  (> (measurement-flag m) 0))

(defun map-data-stream (function stream)
  (flet ((scan (&optional (errorp t)) (read stream errorp nil)))
    (loop
       :with global-count = 0
       :for date = (scan nil) :then (scan nil)
       :for line-number :upfrom 1
       :while date
       :do (loop
	      :for count :upfrom 0 :below 24
	      :do (let* ((value (scan)) (flag (scan)))
		    (funcall function (make-measurement global-count line-number date flag value))
		    (incf global-count)))
       :finally (return global-count))))

(defun map-data-file (function pathname)
  (with-open-file (stream pathname
			  :element-type 'character
			  :direction :input
			  :if-does-not-exist :error)
    (map-data-stream function stream)))

(defmacro do-data-stream ((variable stream) &body body)
  `(map-data-stream
     (lambda (,variable) ,@body)
     ,stream))

(defmacro do-data-file ((variable file) &body body)
  `(map-data-file
     (lambda (,variable) ,@body)
     ,file))

(let ((current-day nil)
      (current-line 0)
      (beginning-of-misreadings nil)
      (current-length 0)
      (worst-beginning nil)
      (worst-length 0)
      (sum-of-day 0)
      (count-of-day 0))

  (flet ((write-end-of-day-report ()
	   (when current-day
	     (format t "Line ~5D Date ~A: Accepted ~2D Total ~8,3F Average ~8,3F~%"
		     current-line current-day count-of-day sum-of-day
		     (if (> count-of-day 0) (/ sum-of-day count-of-day) sum-of-day)))))

    (do-data-file (m #P"D:/Scratch/data.txt")

      (let* ((date (measurement-date m))
	     (line-number (measurement-line m))
	     (validp (measurement-valid-p m))
	     (day-changed-p (/= current-line line-number))
	     (value (measurement-value m)))

	(when day-changed-p
	  (write-end-of-day-report)
	  (setf current-day date)
	  (setf current-line line-number)
	  (setf sum-of-day 0)
	  (setf count-of-day 0))

	(if (not validp)
	    (if beginning-of-misreadings
		(incf current-length)
		(progn
		  (setf beginning-of-misreadings m)
		  (setf current-length 1)))
	    (progn
	      (when beginning-of-misreadings
		(if (> current-length worst-length)
		    (progn
		      (setf worst-beginning beginning-of-misreadings)
		      (setf worst-length current-length))
		    (progn
		      (setf beginning-of-misreadings nil)
		      (setf current-length 0))))
	      (incf sum-of-day value)
	      (incf count-of-day)))))

    (when (and beginning-of-misreadings (> current-length worst-length))
      (setf worst-beginning beginning-of-misreadings)
      (setf worst-length current-length))

    (write-end-of-day-report))

  (format t "Worst run started ~A (~D) and has length ~D~%"
	  (measurement-date worst-beginning)
	  (measurement-counter worst-beginning)
	  worst-length))
