(defun hash (column table)
  (lists:foldl
    (lambda (x acc)
      (orddict:append (proplists:get_value column x) x acc))
    '()
    table))

(defun get-hash (col hash-table)
  (proplists:get_value
     (proplists:get_value col r)
     hashed))

(defun merge (row-1 row-2)
  (orddict:merge
    (lambda (k v1 v2) v2)
    (lists:sort row-1)
    (lists:sort row-2)))

(defun hash-join (table-1 col-1 table-2 col-2)
  (let ((hashed (hash col-1 table-1)))
    (lc ((<- r table-2))
        (lc ((<- s (get-hash col-2 hashed)))
            (merge r s)))))
