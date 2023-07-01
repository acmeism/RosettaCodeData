#lang racket
(define block-strings
  (list "BO" "XK" "DQ" "CP" "NA"
        "GT" "RE" "TG" "QD" "FS"
        "JW" "HU" "VI" "AN" "OB"
        "ER" "FS" "LY" "PC" "ZM"))
(define BLOCKS (map string->list block-strings))

(define (can-make-word? w)
  (define (usable-block blocks word-char)
    (for/first ((b (in-list blocks)) #:when (memf (curry char-ci=? word-char) b)) b))

  (define (inner word-chars blocks tried-blocks)
    (cond
      [(null? word-chars) #t]
      [(usable-block blocks (car word-chars))
       =>
       (lambda (b)
         (or
          (inner (cdr word-chars) (append tried-blocks (remove b blocks)) null)
          (inner word-chars (remove b blocks) (cons b tried-blocks))))]
      [else #f]))
  (inner (string->list w) BLOCKS null))

(define WORD-LIST '("" "A" "BARK" "BOOK" "TREAT" "COMMON" "SQUAD" "CONFUSE"))
(define (report-word w)
  (printf "Can we make: ~a? ~a~%"
          (~s w #:min-width 9)
          (if (can-make-word? w) "yes" "no")))

(module+ main
  (for-each report-word WORD-LIST))

(module+ test
  (require rackunit)
  (check-true  (can-make-word? ""))
  (check-true  (can-make-word? "A"))
  (check-true  (can-make-word? "BARK"))
  (check-false (can-make-word? "BOOK"))
  (check-true  (can-make-word? "TREAT"))
  (check-false (can-make-word? "COMMON"))
  (check-true  (can-make-word? "SQUAD"))
  (check-true  (can-make-word? "CONFUSE")))
