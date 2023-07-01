(defun oid->list (oid)
  (loop for start = 0 then (1+ pos)
        for pos = (position #\. oid :start start)
        collect (parse-integer oid :start start :end pos)
        while pos))

(defun list< (list1 list2)
  (loop for e1 in list1
        for e2 in list2
        do (cond ((< e1 e2)
                  (return t))
                 ((> e1 e2)
                  (return nil)))
        finally (return (< (length list1) (length list2)))))

(defun sort-oids (oids)
  (sort oids #'list< :key #'oid->list))

(defun main ()
  (let ((oids (list "1.3.6.1.4.1.11.2.17.19.3.4.0.10"
                    "1.3.6.1.4.1.11.2.17.5.2.0.79"
                    "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
                    "1.3.6.1.4.1.11150.3.4.0.1"
                    "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
                    "1.3.6.1.4.1.11150.3.4.0")))
    (dolist (oid (sort-oids oids))
      (write-line oid))))
