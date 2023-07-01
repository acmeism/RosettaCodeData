;; CSV -> LISTS
(define (csv->row line)  (map (lambda(x) (or (string->number x) x)) (string-split line ",")))
(define (csv->table csv) (map  csv->row (string-split csv "\n")))

;; LISTS -> CSV
(define (row->csv row) (string-join row ","))
(define (table->csv header rows)
    (string-join  (cons (row->csv header) (for/list ((row rows)) (row->csv row))) "\n"))


(define (task file)
 (let*
 	((table (csv->table file))
 	(header (first table))
 	(rows (rest table)))
 	
 	(table->csv
 		(append header "SUM") ;; add last column
 		(for/list ((row rows)) (append row (apply + row))))))

	
