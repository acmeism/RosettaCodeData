#lang racket/base
(require (only-in racket/list drop-right)
         (only-in racket/string string-trim))

(provide ascii-art->struct)

;; reads ascii art from a string or input-port
;; returns:
;;   list of (word-number highest-bit lowest-bit name-symbol)
;;   bits per word
(define (ascii-art->struct art)
  (define art-inport
    (cond
      [(string? art) (open-input-string art)]
      [(input-port? art) art]
      [else (raise-argument-error 'ascii-art->struct
                                  "(or/c string? input-port?)"
                                  art)]))
  (define lines
    (for/list ((l (in-port (lambda (p)
                             (define pk (peek-char p))
                             (case pk ((#\+ #\|) (read-line p))
                               (else eof)))
                           art-inport)))
      l))
  (when (null? lines)
    (error 'ascii-art->struct "no lines"))
  (define bit-re #px"[|+]([^|+]*)")
  (define cell-re #px"[|]([^|]*)")

  (define bit-boundaries (regexp-match-positions* bit-re (car lines)))

  (define bits/word (sub1 (length bit-boundaries)))

  (unless (zero? (modulo bits/word 8))
    (error 'ascii-art->struct "diagram is not a multiple of 8 bits wide"))

  (define-values (pos->bit-start# pos->bit-end#)
    (for/fold ((s# (hash)) (e# (hash)))
              ((box (in-range bits/word))
               (boundary (in-list bit-boundaries)))
      (define bit (- bits/word box 1))
      (values (hash-set s# (car boundary) bit)
              (hash-set e# (cdr boundary) bit))))

  (define fields
    (apply append
           (for/list ((line-number (in-naturals))
                      (line (in-list lines))
                      #:when (odd? line-number))
             (define word (quotient line-number 2))
             (define cell-positions (regexp-match-positions* cell-re line))
             (define cell-contents (regexp-match* cell-re line))
             (for/list ((cp (in-list (drop-right cell-positions 1)))
                        (cnt (in-list cell-contents)))
               (define cell-start-bit (hash-ref pos->bit-start# (car cp)))
               (define cell-end-bit (hash-ref pos->bit-end# (cdr cp)))
               (list word cell-start-bit cell-end-bit (string->symbol (string-trim (substring cnt 1))))))))
  (values fields bits/word))
