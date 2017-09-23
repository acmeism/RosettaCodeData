(import (scheme base)
        (scheme write)
        (only (srfi 13) string-join string-tokenize))

;; word wrap, using greedy algorithm with minimum lines
(define (simple-word-wrap str width)
  (let loop ((words (string-tokenize str))
             (line-length 0)
             (line '())
             (lines '()))
    (cond ((null? words)
           (reverse (cons (reverse line) lines)))
          ((> (+ line-length (string-length (car words)))
              width)
           (if (null? line)
             (loop (cdr words) ; case where word exceeds line length
                   0
                   '()
                   (cons (list (car words)) lines))
             (loop words ; word must go to next line, so finish current line
                   0
                   '()
                   (cons (reverse line) lines))))
          (else
            (loop (cdr words) ; else, add word to current line
                  (+ 1 line-length (string-length (car words)))
                  (cons (car words) line)
                  lines)))))

;; run examples - text from RnRS report
(define *text* "Programming languages should be designed not by piling feature on top of feature, but by removing the weaknesses and restrictions that make additional features appear necessary. Scheme demonstrates that a very small number of rules for forming expressions, with no restrictions on how they are composed, suffice to form a practical and efficient programming language that is flexible enough to support most of the major programming paradigms in use today.")

(define (show-para algorithm width)
  (display (make-string width #\-)) (newline)
  (for-each (lambda (line) (display (string-join line " ")) (newline))
            (algorithm *text* width)))

(show-para simple-word-wrap 50)
(show-para simple-word-wrap 60)
