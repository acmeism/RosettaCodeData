(defun count-and-say (str)
   (let* ((s (sort (map 'list #'identity str) #'char>))
	  (out (list (first s) 0)))
     (loop for x in s do
	   (if (char= x (first out))
	     (incf (second out))
	     (setf out (nconc (list x 1) out))))
     (format nil "~{~a~^~}" (nreverse out))))

(defun ref-seq-len (n &optional doprint)
  (let ((s (format nil "~d" n)) hist)
    (loop (push s hist)
	  (if doprint (format t "~a~%" s))
	  (setf s (count-and-say s))
	  (loop for item in hist
		for i from 0 to 2 do
		(if (string= s item) (return-from ref-seq-len (length hist)))))))

(defun find-longest (top)
  (let (nums (len 0))
  (dotimes (x top)
    (let ((l (ref-seq-len x)))
      (if (> l len) (setf len l nums nil))
      (if (= l len) (push x nums))))
  (list nums len)))

(let ((r (find-longest 1000000)))
  (format t "Longest: ~a~%" r)
  (ref-seq-len (first (first r)) t))
