;; We will use the Emacs Lisp calendar-generate-month function. This
;; function inserts a calendar at the top of the current buffer. So
;; first, we need a function to insert blank lines at the top of the
;; buffer to leave space for the calendar insertion.

(defun insert-blank-lines-for-calendar (number)
  "Insert NUMBER blank lines at beginning of buffer for calendar."
  (goto-char (point-min))
  (dotimes (i number)
    (insert "\n")))

;; Next, let's print one calendar row at a time.

(defun calendar-row (month year)
  "Print one calendar row for YEAR, beginning with MONTH."
  (insert-blank-lines-for-calendar 9)
  (dotimes (i 3)
    (calendar-generate-month (+ i month) year (* i 25))))

;; Finally, we have one function to call calendar-row 4 times for
;; whole year and to add the header.

(defun rob-calendar (year)
  "Generate calendar for YEAR."
  (let ((row 4)  ;; 4 rows for the calendar
        (month-row-start 10) ;; We start first with the last row, which begins with month 10).
        (year-padding (make-string 33 32)) ;; some padding for the year
        (image-padding (make-string 28 32))) ;; padding for the image placeholder
    (while (> row 0)
      (calendar-row month-row-start year)
      (setq row (- row 1))
      (setq month-row-start (- month-row-start 3)))
    (goto-char (point-min))
    (insert (format "%s%s\n" year-padding year))
    (insert (format "%s[Snoopy image]\n\n" image-padding))))


