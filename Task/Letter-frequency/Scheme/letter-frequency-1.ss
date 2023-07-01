(use-modules (ice-9 format))

(define (char-freq port table)
  (if
   (eof-object? (peek-char port))
   table
   (char-freq port (add-char (read-char port) table))))

(define (add-char char table)
  (cond
   ((null? table) (list (list char 1)))
   ((eq? (caar table) char) (cons (list char (+ (cadar table) 1)) (cdr table)))
   (#t (cons (car table) (add-char char (cdr table))))))

(define (format-table table)
  (for-each (lambda (t) (format #t "~10s~10d~%" (car t) (cadr t))) table))

(define (print-freq filename)
  (format-table (char-freq (open-input-file filename) '())))

(print-freq "letter-frequency.scm")
