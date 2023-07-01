(defvar *db* nil)

(defvar *db-cat* (make-hash-table :test 'equal))

(defvar *db-file* "db.txt")

(defstruct item
  "this is the unit of data stored/displayed in *db*"
  (title " ")
  (category "default")
  (date (progn (get-universal-time))))

(defun set-category(new-item)
  (setf (gethash (item-category new-item) *db-cat*) 't))

(defun find-item-in-db (&optional category)
  (if (null category)
      (car *db*)
    (find category *db* :key #'item-category :test #'string=)))

(defun scan-category ()
  "scan categories from an existing database -- after reading it from disk"
  (dolist (itm *db*) (set-category itm)))

(defun pr-univ-time (utime)
  (multiple-value-bind
   (second minute hour date month year day-of-week dst-p tz)
   (decode-universal-time utime)
   (declare (ignore day-of-week dst-p tz))
   (format nil "~4,'0d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d" year month date hour minute second)))

(defun pr (&optional (item (find-item-in-db)) (stream t))
  "print an item"
  (when item
    (format stream "~a: (~a) (~a)~%"
	    (item-title item)
	    (item-category item)
	    (pr-univ-time (item-date item)))))

(defun pr-per-category ()
  "print the latest item from each category"
  (loop for k being the hash-keys in *db-cat*
	do (pr (find-item-in-db k))))

(defun pr-all ()
  "print all the items, *db* is sorted by time."
  (dolist (itm *db*)  (pr itm)))

(defun pr-all-categories (&optional (stream t))
  (loop for k being the hash-keys in *db-cat*
       do (format stream "(~a) " k)))

(defun insert-item (item)
  "insert item into database in a time sorted list. okay for a small list, as per spec."
  (let ((first-item (car *db*)) (new-itm item))
    (set-category new-itm)
    (push new-itm *db*)
    (when (and first-item (>= (item-date new-itm) (item-date first-item)))
      (setf *db* (sort *db* #'> :key #'item-date)))
    *db*))

(defun read-db-from-file (&optional (file *db-file*))
  (with-open-file (in file :if-does-not-exist nil)
		  (when in
		    (with-standard-io-syntax (setf *db* (read in)))
		    (scan-category))))

(defun save-db-to-file (&optional (file *db-file*))
  (with-open-file (out file :direction :output :if-exists :supersede)
		  (with-standard-io-syntax
		   (print *db* out))))

(defun del-db ()
  (setf *db* nil)
  (save-db-to-file))

(defun del-item (itm)
  (read-db-from-file)
  (setf *db* (remove itm *db* :key #'item-title :test #'string=))
  (save-db-to-file))

(defun add-item-to-db (args)
  (read-db-from-file)
  (insert-item (make-item :title (first args) :category (second args)))
  (save-db-to-file))

(defun help-menu ()
  (format t "clisp db.lisp ~{~15T~a~^~% ~}"
	  '("delete <item-name> -------------------  delete an item"
	    "delete-all ---------------------------  delete the database"
            "insert <item-name> <item-category> ---  insert an item with its category"
	    "show ---------------------------------  shows the latest inserted item"
	    "show-categories ----------------------  show all categories"	
	    "show-all -----------------------------  show all items"
	    "show-per-category --------------------  show the latest item per category")))

(defun db-cmd-run (args)
  (cond ((and (> (length args) 1) (equal (first args) "delete"))
	 (del-item (second args)))
	((equal (first args) "delete-all") (del-db))	
	((and (> (length args) 2) (equal (first args) "insert"))
	 (add-item-to-db (rest args)))
	((equal (first args) "show") (read-db-from-file) (pr))
	((equal (first args) "show-categories") (read-db-from-file) (pr-all-categories))
        ((equal (first args) "show-all") (read-db-from-file) (pr-all))
        ((equal (first args) "show-per-category") (read-db-from-file) (pr-per-category))
        (t (help-menu))))

;; modified https://rosettacode.org/wiki/Command-line_arguments#Common_Lisp
(defun db-argv ()
  (or
   #+clisp ext:*args*
   #+sbcl (cdr sb-ext:*posix-argv*)
   #+allegro (cdr (sys:command-line-arguments))
   #+lispworks (cdr sys:*line-arguments-list*)
   nil))

(db-cmd-run  (db-argv))
