(defun topological-sort (graph &key (test 'eql))
  "Graph is an association list whose keys are objects and whose
values are lists of objects on which the corresponding key depends.
Test is used to compare elements, and should be a suitable test for
hash-tables.  Topological-sort returns two values.  The first is a
list of objects sorted toplogically.  The second is a boolean
indicating whether all of the objects in the input graph are present
in the topological ordering (i.e., the first value)."
  (let ((entries (make-hash-table :test test)))
    (flet ((entry (vertex)
             "Return the entry for vertex.  Each entry is a cons whose
              car is the number of outstanding dependencies of vertex
              and whose cdr is a list of dependants of vertex."
             (multiple-value-bind (entry presentp) (gethash vertex entries)
               (if presentp entry
                 (setf (gethash vertex entries) (cons 0 '()))))))
      ;; populate entries initially
      (dolist (vertex graph)
        (destructuring-bind (vertex &rest dependencies) vertex
          (let ((ventry (entry vertex)))
            (dolist (dependency dependencies)
              (let ((dentry (entry dependency)))
                (unless (funcall test dependency vertex)
                  (incf (car ventry))
                  (push vertex (cdr dentry))))))))
      ;; L is the list of sorted elements, and S the set of vertices
      ;; with no outstanding dependencies.
      (let ((L '())
            (S (loop for entry being each hash-value of entries
                     using (hash-key vertex)
                     when (zerop (car entry)) collect vertex)))
        ;; Until there are no vertices with no outstanding dependencies,
        ;; process vertices from S, adding them to L.
        (do* () ((endp S))
          (let* ((v (pop S)) (ventry (entry v)))
            (remhash v entries)
            (dolist (dependant (cdr ventry) (push v L))
              (when (zerop (decf (car (entry dependant))))
                (push dependant S)))))
        ;; return (1) the list of sorted items, (2) whether all items
        ;; were sorted, and (3) if there were unsorted vertices, the
        ;; hash table mapping these vertices to their dependants
        (let ((all-sorted-p (zerop (hash-table-count entries))))
          (values (nreverse L)
                  all-sorted-p
                  (unless all-sorted-p
                    entries)))))))
