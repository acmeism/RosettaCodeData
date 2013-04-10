(defvar *csv* "Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!")

(defun split-string (string delim-char)
  (let ((result '()))
    (do* ((start 0 (1+ end))
	  (end (position delim-char string)
	       (position delim-char string :start start)))
	 ((not end) (reverse (cons (subseq string start) result)))
      (push (subseq string start end) result))))

;;; HTML escape code modified from:
;;; http://www.gigamonkeys.com/book/practical-an-html-generation-library-the-interpreter.html

(defun escape-char (char)
  (case char
    (#\& "&amp;")
    (#\< "&lt;")
    (#\> "&gt;")
    (t (format nil "&#~d;" (char-code char)))))

(defun escape (in)
  (let ((to-escape "<>&"))
    (flet ((needs-escape-p (char) (find char to-escape)))
      (with-output-to-string (out)
	(loop for start = 0 then (1+ pos)
	   for pos = (position-if #'needs-escape-p in :start start)
	   do (write-sequence in out :start start :end pos)
	   when pos do (write-sequence (escape-char (char in pos)) out)
	   while pos)))))

(defun html-row (values headerp)
  (let ((tag (if headerp "th" "td")))
    (with-output-to-string (out)
      (write-string "<tr>" out)
      (dolist (val values)
	(format out "<~A>~A</~A>" tag (escape val) tag))
      (write-string "</tr>" out))))

(defun csv->html (csv)
  (let* ((lines (split-string csv #\Newline))
	 (cols  (split-string (first lines) #\,))
	 (rows  (mapcar (lambda (row) (split-string row #\,)) (rest lines))))
    (with-output-to-string (html)
      (format html "<table>~C" #\Newline)
      (format html "~C~A~C" #\Tab (html-row cols t) #\Newline)
      (dolist (row rows)
	(format html "~C~A~C" #\Tab (html-row row nil) #\Newline))
      (write-string "</table>" html))))
