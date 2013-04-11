; file:   html-table.lsp
; url:    http://rosettacode.org/wiki/Create_an_HTML_table
; author: oofoe 2012-01-29

(seed (time-of-day)) ; Initialize random number generator.

; The "tab" variable tracks the HTML indent. "pad" composes a line
; with the appropriate indent and a terminal newline.

(setq tab 0)
(define (pad text) (string (dup "  " tab) text "\n"))

; NewLISP allows almost any character in an identifier, so I can name
; my functions after the HTML elements they invoke. This one formats a
; single table data cell.

(define (<td> text) (pad (string "<td>" text "</td>")))

; "<tr>" will accept either a number of arguments, each one to be
; formatted as a table cell, or a single list argument, which is
; broken into table cells. For convenience, I format each list item
; with the "<td>" function so I can feed it raw lists.

(define (<tr>)
  (let ((data (args))
        (s    (pad "<tr>")))

    (if (list? (data 0)) (setq data (data 0)))

    (inc tab)
    (dolist (el data) (extend s (<td> el)))
    (dec tab)

    (extend s (pad "</tr>"))
    s))

; By defining "<table>" as a macro, I ensure that the rows won't be
; evaluated until I've got the table started, which preserves the
; formatting.

(define-macro (<table>)
  (let ((s (pad "<table>")))
    (inc tab) (doargs (row) (extend s (eval row)))  (dec tab)
    (extend s (pad "</table>"))
    s
    ))

; Test

(print (<table> (<tr> "" "X" "Y" "Z")
                (<tr> (cons 0 (rand 1000 3)))
                (<tr> (cons 1 (rand 1000 3)))
                (<tr> (cons 2 (rand 1000 3)))
                ))

(exit)
