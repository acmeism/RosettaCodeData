(defun top-n-by-group (n data value-key group-key predicate &key (group-test 'eql))
  (let ((not-pred (complement predicate))
        (group-data (make-hash-table :test group-test)))
    (labels ((value (datum)
               (funcall value-key datum))
             (insert (x list)
               (merge 'list (list x) list not-pred :key #'value))
             (entry (group)
               "Return the entry for the group, creating it if
                necessary. An entry is a list whose first element is
                k, the number of items currently associated with the
                group (out of n total), and whose second element is
                the list of the k current top items for the group."
               (multiple-value-bind (entry presentp)
                   (gethash group group-data)
                 (if presentp entry
                   (setf (gethash group group-data)
                         (list 0 '())))))
             (update-entry (entry datum)
               "Update the entry using datum. If there are already n
                items associated with the entry, then when datum's value
                is greater than the current least item, data is merged into
                the items, and the list (minus the first element) is
                stored in entry. Otherwise, if there are fewer than n
                items in the entry, datum is merged in, and the
                entry's k is increased by 1."
               (if (= n (first entry))
                 (when (funcall predicate (value datum) (value (first (second entry))))
                   (setf (second entry)
                         (cdr (insert datum (second entry)))))
                 (setf (first entry) (1+ (first entry))
                       (second entry) (insert datum (second entry))))))
      (dolist (datum data group-data)
        (update-entry (entry (funcall group-key datum)) datum)))))
