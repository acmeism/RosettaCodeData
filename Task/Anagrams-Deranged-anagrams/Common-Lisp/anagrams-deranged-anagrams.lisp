(defun read-words (file)
  (with-open-file (stream file)
    (loop with w = "" while w collect (setf w (read-line stream nil)))))

(defun deranged (a b)
  (loop for ac across a for bc across b always (char/= ac bc)))

(defun longest-deranged (file)
  (let ((h (make-hash-table :test #'equal))
	(wordlist (sort (read-words file)
			#'(lambda (x y) (> (length x) (length y))))))
    (loop for w in wordlist do
	  (let* ((ws (sort (copy-seq w) #'char<))
		 (l (gethash ws h)))
	    (loop for w1 in l do
		  (if (deranged w w1)
		    (return-from longest-deranged (list w w1))))
	    (setf (gethash ws h) (cons w l))))))

(format t "~{~A~%~^~}" (longest-deranged "unixdict.txt"))
