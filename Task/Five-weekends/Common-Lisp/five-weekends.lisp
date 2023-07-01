;; Given a date, get the day of the week.  Adapted from
;; http://lispcookbook.github.io/cl-cookbook/dates_and_times.html

(defun day-of-week (day month year)
  (nth-value
   6
   (decode-universal-time
	(encode-universal-time 0 0 0 day month year 0)
	0)))

(defparameter *long-months* '(1 3 5 7 8 10 12))

(defun sundayp (day month year)
  (= (day-of-week day month year) 6))

(defun ends-on-sunday-p (month year)
  (sundayp 31 month year))

;; We use the "long month that ends on Sunday" rule.
(defun has-five-weekends-p (month year)
  (and (member month *long-months*)
	   (ends-on-sunday-p month year)))

;; For the extra credit problem.
(defun has-at-least-one-five-weekend-month-p (year)
  (let ((flag nil))
	(loop for month in *long-months* do
		 (if (has-five-weekends-p month year)
			 (setf flag t)))
	flag))

(defun solve-it ()
  (let ((good-months '())
		(bad-years 0))
	(loop for year from 1900 to 2100 do
	   ;; First form in the PROGN is for the extra credit.
		 (progn (unless (has-at-least-one-five-weekend-month-p year)
				  (incf bad-years))
				(loop for month in *long-months* do
					 (when (has-five-weekends-p month year)
					   (push (list month year) good-months)))))
	(let ((len (length good-months)))
	  (format t "~A months have five weekends.~%" len)
	  (format t "First 5 months: ~A~%" (subseq good-months (- len 5) len))
	  (format t "Last 5 months: ~A~%" (subseq good-months 0 5))
	  (format t "Years without a five-weekend month: ~A~%" bad-years))))
