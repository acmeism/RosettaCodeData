(defun n-grams (text n)
"Return a list of all the N-grams of length n in the text, together with their frequency"
	(let* (res (*ht-n-grams* (make-hash-table :test 'equal)) )
		(loop for i from 0 to (- (length text) n) do
			(let* ((n-gram (string-upcase (subseq text i (+ i n))))
			       (freq (gethash n-gram *ht-n-grams*)))
		  		(setf (gethash n-gram *ht-n-grams*) (if (null freq) 1 (1+ freq))) ))
			(maphash #'(lambda (key val)
									(push (cons key val) res) )
				*ht-n-grams* )
			(sort res #'> :key #'cdr) ))
