(ql:quickload '(date-calc))

(defparameter *day-row* "Su Mo Tu We Th Fr Sa")
(defparameter *calendar-margin* 3)

(defun month-to-word (month)
  "Translate a MONTH from 1 to 12 into its word representation."
  (svref #("January" "February" "March" "April"
           "May" "June" "July" "August"
           "September" "October" "November" "December")
         (1- month)))

(defun month-strings (year month)
  "Collect all of the strings that make up a calendar for a given
MONTH and YEAR."
  `(,(date-calc:center (month-to-word month) (length *day-row*))
     ,*day-row*
     ;; We can assume that a month calendar will always fit into a 7 by 6 block
     ;; of values. This makes it easy to format the resulting strings.
     ,@ (let ((days (make-array (* 7 6) :initial-element nil)))
          (loop :for i :from (date-calc:day-of-week year month 1)
             :for day :from 1 :to (date-calc:days-in-month year month)
             :do (setf (aref days i) day))
          (loop :for i :from 0 :to 5
             :collect
             (format nil "~{~:[  ~;~2,d~]~^ ~}"
                     (loop :for day :across (subseq days (* i 7) (+ 7 (* i 7)))
                        :append (if day (list day day) (list day))))))))

(defun calc-columns (characters margin-size)
  "Calculate the number of columns given the number of CHARACTERS per
column and the MARGIN-SIZE between them."
  (multiple-value-bind (cols excess)
      (truncate characters (+ margin-size (length *day-row*)))
    (incf excess margin-size)
    (if (>= excess (length *day-row*))
        (1+ cols)
        cols)))

(defun take (n list)
  "Take the first N elements of a LIST."
  (loop :repeat n :for x :in list :collect x))

(defun drop (n list)
  "Drop the first N elements of a LIST."
  (cond ((or (<= n 0) (null list)) list)
        (t (drop (1- n) (cdr list)))))

(defun chunks-of (n list)
  "Split the LIST into chunks of size N."
  (assert (> n 0))
  (loop :for x := list :then (drop n x)
     :while x
     :collect (take n x)))

(defun print-calendar (year &key (characters 80) (margin-size 3))
  "Print out the calendar for a given YEAR, optionally specifying
a width limit in CHARACTERS and MARGIN-SIZE between months."
  (assert (>= characters (length *day-row*)))
  (assert (>= margin-size 0))
  (let* ((calendars (loop :for month :from 1 :to 12
                       :collect (month-strings year month)))
         (column-count (calc-columns characters margin-size))
         (total-size (+ (* column-count (length *day-row*))
                        (* (1- column-count) margin-size)))
         (format-string (concatenate 'string
                                     "~{~a~^~" (write-to-string margin-size) ",0@T~}~%")))
    (format t "~a~%~a~%~%"
            (date-calc:center "[Snoopy]" total-size)
            (date-calc:center (write-to-string year) total-size))
    (loop :for row :in (chunks-of column-count calendars)
       :do (apply 'mapcar
                  (lambda (&rest heads)
                    (format t format-string heads))
                  row))))
