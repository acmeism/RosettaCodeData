;; Iterate over the table and create a list of the keys and the
;; altered values:
(hash-table-map
  table
  (lambda (key val) (list key (+ val 5000))))

;; Create a new table that has the same keys but altered values.
(use gauche.collection)
(map-to <hash-table>
  (lambda (k-v) (cons (car k-v) (+ (cdr k-v) 5000)))
  table)
