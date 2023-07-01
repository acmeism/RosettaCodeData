(define (row-above row) (map cell-add (drop row 1) (drop-right row 1)))

(define row0 (list (cell 0 1 0) (cell 11 0 0) (cell 0 1 1) (cell 4 0 0) (cell 0 0 1)))
(define row1 (row-above row0))
(define row2 (row-above row1))
(define row3 (row-above row2))
(define row4 (row-above row3))
