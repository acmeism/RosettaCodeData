(let* ((v1 '(A ()
	      B (1 2 3 4 5)
	      C (1 3 5 7 9)
	      D (2 4 6 8 10)
	      E (2 3 5 7)
	      F (8)))
       (keys1 (seq-filter (lambda (x) (not (null x)))
			  (cl-loop for s1 being the elements of v1
				   using (index idx)
				   collect (if (= (% idx 2) 0) s1 nil)))))

  (switch-to-buffer-other-window "*similarity result*")
  (erase-buffer)

  (defun similarity (p1 p2)
    (if (and (null p1) (null p2)) 1
      (/ (float (seq-length (seq-intersection p1 p2)))
	 (float (seq-length (seq-uniq (seq-union p1 p2))))) ) )

  (insert (format "  %s\n"
		  (cl-loop for s1 being the elements of keys1 concat
			   (format "      %s" s1))))

  (cl-loop for s1 in keys1 do
	   (insert (format "%s %s\n" s1
			   (cl-loop for s2 in keys1 concat
				    (format "  %3.3f" (similarity (plist-get v1 s1) (plist-get v1 s2) ))))))
  )
