(defun merge-hash-tables (hashtable &rest other-hashtables)
  (let ((result (make-hash-table :test (hash-table-test hashtable))))
    (dolist (ht (list* hashtable other-hashtables))
      (maphash #'(lambda (k v) (setf (gethash k result) v)) ht))
    result))

;; aux functions
(defun make-hash-table-from-alist (alist &key (test 'equal))
  (let ((result (make-hash-table :test test)))
    (loop for (k . v) in alist
          do (setf (gethash k result) v))
    result))
(defun make-alist-from-hash-table (hashtable)
  (let ((result ()))
    (maphash #'(lambda (k v) (setf result (acons k v result))) hashtable)
    (nreverse result)))

;; solving the task
(let ((base (make-hash-table-from-alist '(("name" . "Rocket Skates")
                                          ("price" . 12.75)
                                          ("color" . "yellow"))))
      (update (make-hash-table-from-alist '(("price" . 15.25)
                                            ("color" . "red")
                                            ("year" . 1974)))))
  (format t "base: ~a~%update: ~a~%merged: ~a~%"
          (make-alist-from-hash-table base)
          (make-alist-from-hash-table update)
          (make-alist-from-hash-table (merge-hash-tables base update))))
