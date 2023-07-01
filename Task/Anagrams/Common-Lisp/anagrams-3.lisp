(defun read-words (file)
  (with-open-file (stream file)
    (loop with w = "" while w collect (setf w (read-line stream nil)))))

(defun anagram (file)
  (let ((wordlist (read-words file))
	(h (make-hash-table :test #'equal))
	longest)
    (loop for w in wordlist with ws do
	  (setf ws (sort (copy-seq w) #'char<))
	  (setf (gethash ws h) (cons w (gethash ws h))))
    (loop for w being the hash-keys in h using (hash-value wl)
	  with max-len = 0 do
	  (let ((l (length wl)))
	    (if (> l max-len) (setf longest nil max-len l))
	    (if (= l max-len) (push wl longest))))
    longest))

(format t "~{~{~a ~}~^~%~}" (anagram "unixdict.txt"))
