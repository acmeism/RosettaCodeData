(import (scheme base)
        (scheme write)
        (srfi 1)
        (except (srfi 13) string-for-each string-map)
        (srfi 14))

;; text is a list of lines, alignment is left/right/center
;; displays the aligned text in columns with a single space gap
(define (align-columns text alignment)
  (define (split line) ; splits string on $ into list of strings
    (string-tokenize line (char-set-complement (->char-set "$"))))
  (define (extend lst n) ; extends list to length n, by adding "" to end
    (append lst (make-list (- n (length lst)) "")))
  (define (align-word word width) ; align single word to fit width
    (case alignment
      ((left) (string-pad-right word width))
      ((right) (string-pad word width))
      ((center) (let ((rem (- width (string-length word))))
                  (string-pad-right (string-pad word (- width (truncate (/ rem 2))))
                                    width)))))
  ;
  (display alignment) (newline)
  (let* ((text-list (map split text))
         (max-line-len (fold (lambda (text val) (max (length text) val)) 0 text-list))
         (text-lines (map (lambda (line) (extend line max-line-len)) text-list))
         (min-col-widths (map (lambda (col)
                                (fold (lambda (line val)
                                        (max (string-length (list-ref line col))
                                             val))
                                      0
                                      text-lines))
                              (iota max-line-len))))
    (map (lambda (line)
           (map (lambda (word width)
                  (display (string-append (align-word word width)
                                          " ")))
                line min-col-widths)
           (newline))
         text-lines))
  (newline))

;; show example
(define *example*
  '("Given$a$text$file$of$many$lines,$where$fields$within$a$line$"
    "are$delineated$by$a$single$'dollar'$character,$write$a$program"
    "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$"
    "column$are$separated$by$at$least$one$space."
    "Further,$allow$for$each$word$in$a$column$to$be$either$left$"
    "justified,$right$justified,$or$center$justified$within$its$column."))

(align-columns *example* 'left)
(align-columns *example* 'center)
(align-columns *example* 'right)
