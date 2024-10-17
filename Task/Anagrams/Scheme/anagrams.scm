(import (scheme base)
        (scheme char)
        (scheme file)
        (scheme write)
        (srfi 125)  ; hash tables
        (srfi 132)) ; sorting library

;; read in the words
(define (read-groups)
  (with-input-from-file
    "unixdict.txt"
    (lambda ()
      (let ((groups (hash-table string=?)))
        (do ((line (read-line) (read-line)))
          ((eof-object? line) groups)
          (let* ((key (list->string (list-sort char<? (string->list line))))
                 (val (hash-table-ref/default groups key '())))
            (hash-table-set! groups key (cons line val))))))))

;; extract the longest values from given hash-table of groups
(define (largest-groups groups)
  (define (find-largest grps n sofar)
    (cond ((null? grps)
           sofar)
          ((> (length (car grps)) n)
           (find-largest (cdr grps) (length (car grps)) (list (car grps))))
          ((= (length (car grps)) n)
           (find-largest (cdr grps) n (cons (car grps) sofar)))
          (else
            (find-largest (cdr grps) n sofar))))
  (find-largest (hash-table-values groups) 0 '()))

;; print results
(for-each
  (lambda (group)
    (display "[ ")
    (for-each (lambda (word) (display word) (display " ")) group)
    (display "]\n"))
  (list-sort (lambda (a b) (string<? (car a) (car b)))
             (map (lambda (grp) (list-sort string<? grp))
                  (largest-groups (read-groups)))))
