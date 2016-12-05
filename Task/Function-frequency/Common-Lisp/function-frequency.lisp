(defun mapc-tree (fn tree)
  "Apply FN to all elements in TREE."
  (cond ((consp tree)
         (mapc-tree fn (car tree))
         (mapc-tree fn (cdr tree)))
        (t (funcall fn tree))))

(defun count-source (source)
  "Load and count all function-bound symbols in a SOURCE file."
  (load source)
  (with-open-file (s source)
    (let ((table (make-hash-table)))
      (loop for data = (read s nil nil)
         while data
         do (mapc-tree
             (lambda (x)
               (when (and (symbolp x) (fboundp x))
                 (incf (gethash x table 0))))
             data))
      table)))

(defun hash-to-alist (table)
  "Convert a hashtable to an alist."
  (let ((alist))
    (maphash (lambda (k v) (push (cons k v) alist)) table)
    alist))

(defun take (n list)
  "Take at most N elements from LIST."
  (loop repeat n for x in list collect x))

(defun top-10 (table)
  "Get the top 10 from the source counts TABLE."
  (take 10 (sort (hash-to-alist table) '> :key 'cdr)))
