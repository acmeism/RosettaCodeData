(define (sexpr-read port)
  (define (help port)
    (let ((char (read-char port)))
      (cond
       ((or (eof-object? char) (eq? char #\) )) '())
       ((eq? char #\( ) (cons (help port) (help port)))
       ((char-whitespace? char) (help port))
       ((eq? char #\"") (cons (quote-read port) (help port)))
       (#t (unread-char char port) (cons (string-read port) (help port))))))
  ; This is needed because the function conses all parsed sexprs onto something,
  ; so the top expression is one level too deep.
  (car (help port)))

(define (quote-read port)
  (define (help port)
    (let ((char (read-char port)))
      (if
       (or (eof-object? char) (eq? char #\""))
       '()
       (cons char (help port)))))
  (list->string (help port)))

(define (string-read port)
  (define (help port)
    (let ((char (read-char port)))
      (cond
       ((or (eof-object? char) (char-whitespace? char)) '())
       ((eq? char #\) ) (unread-char char port) '())
       (#t (cons char (help port))))))
  (list->string (help port)))

(define (format-sexpr expr)
  (define (help expr pad)
    (if
     (list? expr)
     (begin
      (format #t "~a(~%" (make-string pad #\tab))
      (for-each (lambda (x) (help x (1+ pad))) expr)
      (format #t "~a)~%" (make-string pad #\tab)))
     (format #t "~a~a~%" (make-string pad #\tab) expr)))
  (help expr 0))

(format-sexpr (sexpr-read
 (open-input-string "((data \"quoted data\" 123 4.5) (data (!@# (4.5) \"(more\" \"data)\")))")))
