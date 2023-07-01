;; Path format: (start-point end-point previous-point distance)
(setq path-list `(
		  (a b ,nil 7)
		  (a c ,nil 9)
		  (a f ,nil 14)
		  (b c ,nil 10)
		  (b d ,nil 15)
		  (c d ,nil 11)
		  (c f ,nil 2)
		  (d e ,nil 6)
		  (e f ,nil 9)
		  ))

(defun calculate-shortest-path ()
  (let ((shortest-path '())
	(head-point (nth 0 (nth 0 path-list))))

    (defun combine-new-path (path1 path2)
      (list (nth 0 path1) (nth 1 path2) (nth 0 path2)
	    (+ (nth 3 path1) (nth 3 path2))) )

    (defun find-shortest-path (start end)
      (seq-find (lambda (item)
		  (and (eq (nth 0 item) start) (eq (nth 1 item) end)))
		shortest-path)
      )

    (defun add-shortest-path (item)
      (add-to-list 'shortest-path item) )


    (defun process-path (path)

      (if (eq head-point (nth 0 path))
	  (add-to-list 'shortest-path path)
	(progn
	  (dolist (spath shortest-path)
	    (when (eq (nth 1 spath) (nth 0 path))
	      (let* ((new-path (combine-new-path spath path))
		     (spath-found (find-shortest-path (nth 0 new-path)
						      (nth 1 new-path))))
		(if spath-found
		    (when (< (nth 3 new-path) (nth 3 spath-found))
		      (setcdr (nthcdr 1 spath-found) (list (nth 2 new-path) (nth 3 new-path)))
		      )

		  (add-shortest-path new-path)) ) ) ) ) ) )


    (defun find-shortest-route (start end)
      (let ((point-list '())
	    (end-point end)
	    path-found)
	(add-to-list 'point-list end)
	(catch 'no-more-path
	  (while 't
	    (setq path-found (find-shortest-path start end-point))
	    (if (or (not path-found) (not (nth 2 path-found)))
		(throw 'no-more-path nil)
	      (progn
		(add-to-list 'point-list (nth 2 path-found))
		(setq end-point (nth 2 path-found)) )
	      )
	    )
	  )
	(add-to-list 'point-list start)
	)
      )

    (defun show-shortest-path (start end)
      (let ((path-found (find-shortest-path start end))
	    (route-found (find-shortest-route start end)))
	(if path-found
	    (progn
	      (message "shortest distance: %s" (nth 3 path-found))
	      (message "shortest route: %s" route-found) )
	  (message "shortest path not found") )
	)
      (message "--") )

    ;; Process each path
    (dolist (path path-list)
      (process-path path) )

    (message "from %s to %s:" 'a 'e)
    (show-shortest-path 'a 'e)
    (message "from %s to %s:" 'a 'f)
    (show-shortest-path 'a 'f)

    )
  )

(calculate-shortest-path)
