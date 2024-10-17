(import (scheme base)
        (scheme char)
        (scheme file)
        (scheme process-context)
        (scheme write))

(define *symbols* (list (cons #\( 'LeftParen)
                        (cons #\) 'RightParen)
                        (cons #\{ 'LeftBrace)
                        (cons #\} 'RightBrace)
                        (cons #\; 'Semicolon)
                        (cons #\, 'Comma)
                        (cons #\* 'Op_multiply)
                        (cons #\/ 'Op_divide)
                        (cons #\% 'Op_mod)
                        (cons #\+ 'Op_add)
                        (cons #\- 'Op_subtract)))

(define *keywords* (list (cons 'if 'Keyword_if)
                         (cons 'else 'Keyword_else)
                         (cons 'while 'Keyword_while)
                         (cons 'print 'Keyword_print)
                         (cons 'putc 'Keyword_putc)))

;; return list of tokens from current port
(define (read-tokens)
  ; information on position in input
  (define line 1)
  (define col 0)
  (define next-char #f)
  ; get char, updating line/col posn
  (define (get-next-char)
    (if (char? next-char) ; check for returned character
      (let ((c next-char))
        (set! next-char #f)
        c)
      (let ((c (read-char)))
        (cond ((and (not (eof-object? c))
                    (char=? c #\newline))
               (set! col 0)
               (set! line (+ 1 line))
               (get-next-char))
              (else
                (set! col (+ 1 col))
                c)))))
  (define (push-char c)
    (set! next-char c))
  ; step over any whitespace or comments
  (define (skip-whitespace+comment)
    (let loop ()
      (let ((c (get-next-char)))
        (cond ((eof-object? c)
               '())
              ((char-whitespace? c) ; ignore whitespace
               (loop))
              ((char=? c #\/) ; check for comments
               (if (char=? (peek-char) #\*) ; found start of comment
                 (begin ; eat comment
                   (get-next-char)
                   (let m ((c (get-next-char)))
                     (cond ((eof-object? c)
                            (error "End of file in comment"))
                           ((and (char=? c #\*)
                                 (char=? (peek-char) #\/))
                            (get-next-char)) ; eat / and end
                           (else
                             (m (get-next-char)))))
                   (loop)) ; continue looking for whitespace / more comments
                 (push-char #\/))) ; not comment, so put / back and return
              (else ; return to stream, as not a comment or space char
                (push-char c))))))
  ; read next token from input
  (define (next-token)
    (define (read-string) ; returns string value along with " "  marks
      (let loop ((chars '(#\"))) ; " (needed to appease Rosetta code's highlighter)
        (cond ((eof-object? (peek-char))
               (error "End of file while scanning string literal."))
              ((char=? (peek-char) #\newline)
               (error "End of line while scanning string literal."))
              ((char=? (peek-char) #\") ; "
               (get-next-char) ; consume the final quote
               (list->string (reverse (cons #\" chars)))) ; "  highlighter)
              (else
                (loop (cons (get-next-char) chars))))))
    (define (read-identifier initial-c) ; returns identifier as a Scheme symbol
      (do ((chars (list initial-c) (cons c chars))
           (c (get-next-char) (get-next-char)))
        ((or (eof-object? c) ; finish when hit end of file
             (not (or (char-numeric? c) ; or a character not permitted in an identifier
                      (char-alphabetic? c)
                      (char=? c #\_))))
         (push-char c) ; return last character to stream
         (string->symbol (list->string (reverse chars))))))
    (define (read-number initial-c) ; returns integer read as a Scheme integer
      (let loop ((res (digit-value initial-c))
                 (c (get-next-char)))
        (cond ((char-alphabetic? c)
               (error "Invalid number - ends in alphabetic chars"))
              ((char-numeric? c)
               (loop (+ (* res 10) (digit-value c))
                     (get-next-char)))
              (else
                (push-char c) ; return non-number to stream
                res))))
    ; select op symbol based on if there is a following = sign
    (define (check-eq-extend start-line start-col opeq op)
      (if (char=? (peek-char) #\=)
        (begin (get-next-char) ; consume it
               (list start-line start-col opeq))
        (list start-line start-col op)))
    ;
    (let* ((start-line line)   ; save start position of tokens
           (start-col col)
           (c (get-next-char)))
      (cond ((eof-object? c)
             (list start-line start-col 'End_of_input))
            ((char-alphabetic? c) ; read an identifier
             (let ((id (read-identifier c)))
               (if (assq id *keywords*) ; check if identifier is a keyword
                 (list start-line start-col (cdr (assq id *keywords*)))
                 (list start-line start-col 'Identifier id))))
            ((char-numeric? c) ; read a number
             (list start-line start-col 'Integer (read-number c)))
            (else
              (case c
                ((#\( #\) #\{ #\} #\; #\, #\* #\/ #\% #\+ #\-)
                 (list start-line start-col (cdr (assq c *symbols*))))
                ((#\<)
                 (check-eq-extend start-line start-col 'Op_lessequal 'Op_less))
                ((#\>)
                 (check-eq-extend start-line start-col 'Op_greaterequal 'Op_greater))
                ((#\=)
                 (check-eq-extend start-line start-col 'Op_equal 'Op_assign))
                ((#\!)
                 (check-eq-extend start-line start-col 'Op_notequal 'Op_not))
                ((#\& #\|)
                 (if (char=? (peek-char) c) ; looks for && or ||
                   (begin (get-next-char) ; consume second character if valid
                          (list start-line start-col
                                (if (char=? c #\&) 'Op_and 'Op_or)))
                   (push-char c)))
                ((#\") ; "
                 (list start-line start-col 'String (read-string)))
                ((#\')
                 (let* ((c1 (get-next-char))
                        (c2 (get-next-char)))
                   (cond ((or (eof-object? c1)
                              (eof-object? c2))
                          (error "Incomplete character constant"))
                         ((char=? c1 #\')
                          (error "Empty character constant"))
                         ((and (char=? c2 #\') ; case of single character
                               (not (char=? c1 #\\)))
                          (list start-line start-col 'Integer (char->integer c1)))
                         ((and (char=? c1 #\\) ; case of escaped character
                               (char=? (peek-char) #\'))
                          (get-next-char) ; consume the ending '
                          (cond ((char=? c2 #\n)
                                 (list start-line start-col 'Integer 10))
                                ((char=? c2 #\\)
                                 (list start-line start-col 'Integer (char->integer c2)))
                                (else
                                  (error "Unknown escape sequence"))))
                         (else
                           (error "Multi-character constant")))))
                (else
                  (error "Unrecognised character")))))))
  ;
  (let loop ((tokens '())) ; loop, ignoring space/comments, while reading tokens
    (skip-whitespace+comment)
    (let ((tok (next-token)))
      (if (eof-object? (peek-char)) ; check if at end of input
        (reverse (cons tok tokens))
        (loop (cons tok tokens))))))

(define (lexer filename)
  (with-input-from-file filename
                        (lambda () (read-tokens))))

;; output tokens to stdout, tab separated
;; line number, column number, token type, optional value
(define (display-tokens tokens)
  (for-each
    (lambda (token)
      (display (list-ref token 0))
      (display #\tab) (display (list-ref token 1))
      (display #\tab) (display (list-ref token 2))
      (when (= 4 (length token))
        (display #\tab) (display (list-ref token 3)))
      (newline))
    tokens))

;; read from filename passed on command line
(if (= 2 (length (command-line)))
  (display-tokens (lexer (cadr (command-line))))
  (display "Error: provide program filename\n"))
