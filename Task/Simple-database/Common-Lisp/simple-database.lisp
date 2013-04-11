(defvar *db* nil)

(defstruct series description tags episodes)

(defstruct (episode (:print-function print-episode-struct))
  series title season episode part date tags)

(defun format-ymd (date)
  (format nil "~{~a.~a.~a~}" date))

(defun print-episode-struct (ep stream level)
  (let ((*print-pretty* nil))
    (format stream (if *print-escape*
                     "#s(episode~@{~*~@[ :~1:*~a ~s~]~})"
                     "~32<~*~a~; ~*~@[~d-~]~*~d~>  ~45<~*~@[~a ~]~*~@[(~a) ~]~;~*~@[(~a)~]~>~*~@[ (~{~a~^ ~})~]")
            :series (episode-series ep)
            :season (episode-season ep)
            :episode (episode-episode ep)
            :title (episode-title ep)
            :part (episode-part ep)
            :date (if *print-escape*
                    (episode-date ep)
                    (when (episode-date ep)
                      (format-ymd (episode-date ep))))
            :tags (episode-tags ep))))

(defun get-value (key alist)
  (cdr (assoc key alist)))


(defun get-latest (database)
  (when database
    (cons (car (series-episodes (cdar database))) (get-latest (cdr database)))))

(defun get-all (database)
  (when database
    (append (series-episodes (cdar database)) (get-all (cdr database)))))

(defun compare-date (a b)
  (cond ((not a) t)
        ((not b) nil)
        ((= (first a) (first b))
         (compare-date (rest a) (rest b)))
        (t (< (first a) (first b)))))

(defun compare-by-date (a b)
  (compare-date (episode-date a) (episode-date b)))

(defun prompt-read (prompt &optional default)
  (format *query-io* "~a~@[ (~a)~]: " prompt default)
  (force-output *query-io*)
  (let ((answer (read-line *query-io*)))
    (if (string= answer "")
      default
      answer)))

(defun split (seperator string)
  (loop for i = 0 then (1+ j)
        as j = (search seperator string :start2 i)
        collect (subseq string i j)
        while j))

(defun get-current-date ()
  (multiple-value-bind
    (second minute hour date month year day-of-week dst-p tz)
    (get-decoded-time)
    (declare (ignore second minute hour day-of-week dst-p tz))
    (list date month year)))


(defun parse-date (date)
  (reverse (mapcar #'parse-integer (split "." date))))

(defun parse-tags (tags)
  (when (and tags (string-not-equal "" tags))
    (mapcar #'intern (split " " (string-upcase tags)))))

(defun parse-number (number)
  (if (stringp number)
    (parse-integer number :junk-allowed t)
    number))

(defun prompt-for-episode (&optional last)
  (when (not last)
    (setf last (make-episode)))
  (let* ((series (prompt-read "Series Title" (episode-series last)))
         (title (prompt-read "Title"))
         (season (parse-number (prompt-read "Season" (episode-season last))))
         (episode (parse-number (prompt-read "Episode"
                                             (if (eq (episode-season last) season)
                                               (1+ (episode-episode last))
                                               1))))
         (part (parse-number (prompt-read "Part"
                                          (when (and (episode-part last)
                                                     (or (eq (episode-season last) season)
                                                         (eq (episode-part last) 1)))
                                            (1+ (episode-part last))))))
         (date (parse-date (prompt-read "Date watched" (format-ymd (get-current-date)))))
         (tags (parse-tags (prompt-read "Tags"))))
    (make-episode
      :series series
      :title title
      :season season
      :episode episode
      :part part
      :date date
      :tags tags)))

(defun parse-integer-quietly (&rest args)
  (ignore-errors (apply #'parse-integer args)))

(defun get-next-version (basename)
  (flet ((parse-version (pathname)
           (or (parse-integer-quietly
                 (string-left-trim (file-namestring basename)
                                   (file-namestring pathname))
                 :start 1) 0)))
    (let* ((files (directory (format nil "~A,*" (namestring basename))))
           (max (if files
                   (reduce #'max files :key #'parse-version)
                   0)))
      (merge-pathnames (format nil "~a,~d" (file-namestring basename) (1+ max))
        basename))))

(defun save-db (dbfile database)
  (let ((file (probe-file dbfile)))
    (rename-file file (get-next-version file))
    (with-open-file (out file :direction :output)
      (with-standard-io-syntax
        (let ((*print-case* :downcase))
          (pprint database out))))))

(defun watch-save (dbfile)
  (save-db dbfile *db*))

(defun load-db (dbfile)
  (with-open-file (in dbfile)
    (with-standard-io-syntax
      (read in))))

(defun get-series (name database)
  (cdr (assoc name database :test #'string-equal)))

(defun get-episode-list (series database)
  (series-episodes (get-series series database)))

(defun print-series (title series)
  (format t "~&~30a ~@[ (~{~a~^ ~})~]~%~@[    ~a~%~]" title (series-tags series)
          (series-description series))
  (format t "~{~&  ~a~%~}" (reverse (series-episodes series))))

(defun watch-series (title)
  (let ((series (get-series title *db*)))
    (when series
      (print-series title series))))

(defun print-all-series (database)
  (loop for (title . series)
        in (sort database #'(lambda (a b)(compare-by-date (car (series-episodes (cdr a)))
                                                          (car (series-episodes (cdr b))))))
        do (terpri) (print-series title series)))

(defun watch-all-series ()
  (print-all-series *db*))

(defun watch-latest ()
  (format t "~{~&  ~a~%~}" (sort (get-latest *db*) #'compare-by-date)))

(defun timeline-all (database)
  (let* ((all (get-all database))
         (max (length all))
         (count max)
         (all-series-names nil)
         (all-series (make-hash-table :test 'equal)))
    (loop for episode in (reverse (sort all #'compare-by-date))
          do (unless (gethash (episode-series episode) all-series)
               (setf (gethash (episode-series episode) all-series)
                     (make-array max :initial-element nil))
               (setf all-series-names
                     (cons (episode-series episode) all-series-names)))
          (setf (elt (gethash (episode-series episode) all-series) (decf count))
                episode))
    (values all-series all-series-names max)))

(defun watch-timeline ()
  (multiple-value-bind (all-series all-series-names max) (timeline-all *db*)
    (loop for series in all-series-names
          do (format t "~30a (~{~:[ ~;•~]~})~%" series
                     (coerce (subseq (gethash series all-series) (- max 60)) 'list)))))

(defun watch-timelinec ()
  (multiple-value-bind (all-series all-series-names max) (timeline-all *db*)
    (let ((chart (make-array (list (length all-series-names) max) :initial-element nil))
          (newcol 0)
          (oldrow -1))
      (loop for oldcol upto (1- max)
            do (loop for series in all-series-names
                     for row from 0 upto (length all-series-names)
                     do (when (elt (gethash series all-series) oldcol)
                          (when (<= row oldrow)
                            (incf newcol))
                          (setf (aref chart row newcol)
                                (elt (gethash series all-series) oldcol))
                          (setf oldrow row))))
      (loop for series in all-series-names
            for i from 0 upto (length all-series-names)
            do (format t "~30a (" series)
            (loop for j from (- newcol 60) upto newcol
                  do (format t "~:[ ~;•~]" (aref chart i j))
                  (if (= j newcol)
                    (format t ")~%")))))))

(defun watch-timelinev ()
  (multiple-value-bind (all-series all-series-names max) (timeline-all *db*)
    (loop for series in all-series-names
          counting series into count
          do (format t "~va ~30a~%" count " " series ))
    (loop for i from 0 upto (1- max)
          do (let ((episode nil))
               (loop for series in all-series-names
                     do (format t "~:[ ~;~:*~02a~]"
                                (when (elt (gethash series all-series) i)
                                  (setf episode (elt (gethash series all-series) i))
                                  (episode-episode episode))))
               (format t " (~a)~%" (episode-series episode))))))

(defun watch-all ()
  (format t "~{~&  ~a~%~}" (sort (get-all *db*) #'compare-by-date)))

(defun watch-new-series (&key name description tags)
  (cdar (push (cons name (make-series :description description :tags tags)) *db*)))

(defun get-or-add-series (name database)
  (or (get-series name database)
      (if (y-or-n-p "Add new series? [y/n]: ")
        (watch-new-series
          :name name
          :description (prompt-read "Description" name)
          :tags (parse-tags (prompt-read "Tags" "active")))
        nil)))

(defun watch-add ()
  (let* ((series (loop thereis (get-or-add-series (prompt-read "Series") *db*)))
         (episode (prompt-for-episode (car (series-episodes series)))))
    (push episode (series-episodes series))))

(defun watch-series-names ()
  (format T "~{~& ~a~%~}"
          (sort (mapcar #'car *db*)
                (lambda (series1 series2)
                  (compare-by-date (car (series-episodes (get-value series1 *db*)))
                                   (car (series-episodes (get-value series2 *db*))))))))

(defun exact-match (term text)
  (string-equal (format nil "~{~a~^ ~}" term) text))

(defun fuzzy-match (term text)
  (loop for word in term
        when (search word text :test 'string-equal)
        collect it))

(defun match-tags (term tags)
  (intersection (mapcar #'intern term) tags))

(defun search-title (term database)
  (loop for episode in (get-all database)
        when (exact-match term (episode-title episode))
        collect episode))

(defun search-tags (term database)
  (sort (loop for episode in (get-all database)
              for matches = (match-tags term (episode-tags episode))
              when matches collect (list (length matches) episode))
        #'> :key #'car))

(defun search-title-fuzzy (term database)
  (sort (loop for episode in (get-all database)
              for matches = (fuzzy-match term (episode-title episode))
              when matches collect (list (length matches) episode))
        #'> :key #'car))

(defun search-all (term database)
  (let ((exact-results '())
        (fuzzy-results '())
        (tag-results '()))
    (dolist (episode (get-all database))
      (cond ((exact-match term (episode-title episode))
             (push episode exact-results))
            ((fuzzy-match term (episode-title episode))
             (push episode fuzzy-results))
            ((match-tags term (episode-tags episode))
             (push episode tag-results))))
    (append (sort exact-results #'compare-by-date)
            (sort tag-results #'compare-by-date)
            (sort fuzzy-results #'compare-by-date))))

(defun watch-search (term)
  (format t "~{~&  ~a~%~}" (search-all term *db*)))

(defun list-all-tags (database)
  (let ((tags (make-hash-table :test 'equal)))
    (dolist (tag (apply #'append (mapcar #'episode-tags (get-all database))))
      (setf (gethash tag tags) (1+ (or (gethash tag tags) 0))))
    tags))

(defun watch-tags ()
  (maphash #'(lambda (tag count) (format t "~a (~d)  " tag count))
           (list-all-tags *db*))
  (terpri))

(defun find-series-episode (term database)
  (let ((series (get-series (format nil "~{~a~^ ~}" (butlast term)) database)))
    (if series
      (let* ((season-episode (car (last term)))
             (pos (position #\- season-episode))
             (season-str (when pos (subseq season-episode 0 pos)))
             (season (or (parse-integer-quietly season-str) season-str))
             (episode-str (if pos
                            (subseq season-episode (1+ pos))
                            season-episode))
             (episode-nr (or (parse-integer-quietly episode-str) episode-str)))
        (loop for episode in (series-episodes series)
              when (and (equal (episode-episode episode) episode-nr)
                        (equal (episode-season episode) season))
              collect episode))
      (let ((series (get-series (format nil "~{~a~^ ~}" term) database)))
        (if series
          (list (car (series-episodes series))))))))


(defun find-episode (term database)
  (or (find-series-episode term database)
      (search-title term database)
      (let* ((res (or (search-tags term database)
                      (search-title-fuzzy term database)))
             (max (caar res)))
        (loop for (matches episode) in res when (equal matches max) collect episode))))

(defun edit-episode (episode database)
  (format t "editing:~%~a~%" episode)
  (setf (episode-series episode)
        (prompt-read "Series Title" (episode-series episode)))
  (setf (episode-title episode)
        (prompt-read "Title" (episode-title episode)))
  (setf (episode-season episode)
        (parse-number (prompt-read "Season" (episode-season episode))))
  (setf (episode-episode episode)
        (parse-number (prompt-read "Episode" (episode-episode episode))))
  (setf (episode-part episode)
        (parse-number (prompt-read "Part" (episode-part episode))))
  (setf (episode-date episode)
        (parse-date (prompt-read "Date watched" (format-ymd (episode-date episode)))))
  (setf (episode-tags episode)
        (parse-tags (prompt-read "Tags" (format nil "~{~a~^ ~}" (episode-tags episode))))))

(defun watch-edit (term)
  (let ((episodes (find-episode term *db*)))
    (if (> (length episodes) 1)
      (format t "found more than one episode, please be more specific:~%~{~&  ~a~%~}" episodes)
      (edit-episode (car episodes) *db*))))

(defun watch-load (dbfile)
  (setf *db* (load-db dbfile)))


(defun argv ()
  (or
    #+clisp (ext:argv)
    #+sbcl sb-ext:*posix-argv*
    #+clozure (ccl::command-line-arguments)
    #+gcl si:*command-args*
    #+ecl (loop for i from 0 below (si:argc) collect (si:argv i))
    #+cmu extensions:*command-line-strings*
    #+allegro (sys:command-line-arguments)
    #+lispworks sys:*line-arguments-list*
    nil))

(defun main (argv)
  (let ((dbfile (make-pathname :name "lwatch" :type nil :defaults *load-pathname*)))
    (watch-load dbfile)
    (format t "loaded db~%")
    (cond ((equal (cadr argv) "add") (watch-add) (watch-save dbfile))
          ((equal (cadr argv) "latest") (watch-latest))
          ((null (cadr argv)) (watch-latest))
          ((equal (cadr argv) "series") (watch-series-names))
          ((and (equal (cadr argv) "all") (equal (caddr argv) "series")) (watch-all-series))
          ((equal (cadr argv) "all") (watch-all))
          ((equal (cadr argv) "tags") (watch-tags))
          ((equal (cadr argv) "search") (watch-search (cddr argv)))
          ((equal (cadr argv) "edit") (watch-edit (cddr argv)) (watch-save dbfile))
          ((equal (cadr argv) "timeline") (watch-timeline))
          ((equal (cadr argv) "timelinev") (watch-timelinev))
          ((equal (cadr argv) "timelinec") (watch-timelinec))
          (T (watch-series (format nil "~{~a~^ ~}" (cdr argv)))))))

(main (argv))
