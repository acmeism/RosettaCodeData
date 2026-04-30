(defvar path-list '((a b 7)
		    (a c 9)
		    (a f 14)
		    (b c 10)
		    (b d 15)
		    (c d 11)
		    (c f 2)
		    (d e 6)
		    (e f 9)))

(defun calculate-shortest-path (path-list)
  (let (shortest-path)
    (dolist (path path-list)
      (add-to-list 'shortest-path (list (nth 0 path)
                                        (nth 1 path)
                                        nil
                                        (nth 2 path))
                   't))

    (dolist (path path-list)
      (dolist (short-path shortest-path)

        (when (equal (nth 0 path) (nth 1 short-path))
          (let ((test-path (list (nth 0 short-path)
                                 (nth 1 path)
                                 (nth 0 path)
                                 (+ (nth 2 path) (nth 3 short-path))))
                is-path-found)

            (dolist (short-path1 shortest-path)
              (when (equal (seq-take test-path 2)
                           (seq-take short-path1 2))
                (setq is-path-found 't)
                (when (> (nth 3 short-path1) (nth 3 test-path))
                  (setcdr (cdr short-path1) (cddr test-path)))))

            (when (not is-path-found)
              (add-to-list 'shortest-path test-path 't))))))

    shortest-path))

(defun find-shortest-route (from to path-list)
  (let ((shortest-path-list (calculate-shortest-path path-list))
        point-list matched-path distance)
    (add-to-list 'point-list to)
    (setq matched-path
          (seq-find (lambda (path) (equal (list from to) (seq-take path 2)))
                    shortest-path-list))
    (setq distance (nth 3 matched-path))
    (while (nth 2 matched-path)
      (add-to-list 'point-list (nth 2 matched-path))
      (setq to (nth 2 matched-path))
      (setq matched-path
            (seq-find (lambda (path) (equal (list from to) (seq-take path 2)))
                      shortest-path-list)))
    (if matched-path
        (progn
          (add-to-list 'point-list from)
          (list 'route point-list 'distance distance))
      nil)))

(format "%S" (find-shortest-route 'a 'e path-list))
