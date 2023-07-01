#lang racket

(define e.g.-CSV
  (string-join
   '("Character,Speech"
     "The multitude,The messiah! Show us the messiah!"
     "Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>"
     "The multitude,Who are you?"
     "Brians mother,I'm his mother; that's who!"
     "The multitude,Behold his mother! Behold his mother!")
   "\n"))

(define (CSV-lines->HTML-table csv)
  (define csv-rows
    (regexp-split "\n" csv))
  (define csv-row-cells
    (map (lambda (row) (regexp-split "," row)) csv-rows))
  (define (cell-data->HTML-data data)
    `(td () ,data))
  (define (row-data->HTML-row CSV-row)
    `(tr () ,@(map cell-data->HTML-data CSV-row) "\n"))
  `(table
    (thead
     ,(row-data->HTML-row (car csv-row-cells)))
    (tbody ,@(map row-data->HTML-row (cdr csv-row-cells)))))

(require xml)
(display (xexpr->string (CSV-lines->HTML-table e.g.-CSV)))
