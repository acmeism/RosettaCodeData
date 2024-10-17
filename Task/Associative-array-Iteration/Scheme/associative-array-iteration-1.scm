;; Create an associative array (hash-table) whose keys are strings:
(define table (hash-table 'string=?
  '("hello" . 0) '("world" . 22) '("!" . 999)))

;; Iterate over the table, passing the key and the value of each entry
;; as arguments to a function:
(hash-table-for-each
  table
  ;; Create by "partial application" a function that accepts 2 arguments,
  ;; the key and the value:
  (pa$ format #t "Key = ~a, Value = ~a\n"))
