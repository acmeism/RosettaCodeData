(defun make-multi-map (rows)
    (let ((multi-map nil))
      (cl-loop for row in rows do
	       (let* ((name (car row))
		      (name-list (assoc name multi-map)))
		 (if name-list
		     (nconc name-list (list row))
		   (progn
		     (add-to-list 'multi-map (list name row) 't) ) ) ) )
      multi-map) )

(defun join-tables (table1 table2)
  (let ((multi-map (make-multi-map table2))
	(result-table '()))
    (cl-loop for row in table1 do
	     (let ((multi-rc (assoc (cdr row) multi-map)))
	       (when multi-rc
		 (cl-loop for multi-line in (cdr multi-rc) do
			  (add-to-list 'result-table
				       (list (car row) (cdr row) (car multi-line) (cdr multi-line))
				       't)))))
    result-table))

(let ((table1 '((27 . "Jonah")
		(18 . "Alan")
		(28 . "Glory")
		(18 . "Popeye")
		(28 . "Alan")))
      (table2 '(("Jonah" . "Whales")
	    ("Jonah" . "Spiders")
	    ("Alan" . "Ghosts")
	    ("Alan" . "Zombies")
	    ("Glory" . "Buffy"))))
  (message "%s" (join-tables table1 table2)) )
