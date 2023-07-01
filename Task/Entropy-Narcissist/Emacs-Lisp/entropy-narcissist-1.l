(defun shannon-entropy (input)
  (let ((freq-table (make-hash-table))
	(entropy 0)
	(length (+ (length input) 0.0)))
    (mapcar (lambda (x)
	      (puthash x
		       (+ 1 (gethash x freq-table 0))
		       freq-table))
	    input)
    (maphash (lambda (k v)
	       (set 'entropy (+ entropy
			     (* (/ v length)
				(log (/ v length) 2)))))
	     freq-table)
  (- entropy)))

(defun narcissist ()
  (shannon-entropy (with-temp-buffer
		     (insert-file-contents "U:/rosetta/narcissist.el")
		     (buffer-string))))
