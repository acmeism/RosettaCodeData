(import (scheme base)
        (scheme process-context)
        (scheme write))

(define *names* (list (cons 'Op_add 'Add)
                      (cons 'Op_subtract 'Subtract)
                      (cons 'Op_multiply 'Multiply)
                      (cons 'Op_divide 'Divide)
                      (cons 'Op_mod 'Mod)
                      (cons 'Op_not 'Not)
                      (cons 'Op_equal 'Equal)
                      (cons 'Op_notequal 'NotEqual)
                      (cons 'Op_or 'Or)
                      (cons 'Op_and 'And)
                      (cons 'Op_less 'Less)
                      (cons 'Op_lessequal 'LessEqual)
                      (cons 'Op_greater 'Greater)
                      (cons 'Op_greaterequal 'GreaterEqual)))

(define (retrieve-name type)
  (let ((res (assq type *names*)))
    (if res
      (cdr res)
      (error "Unknown type name"))))

;; takes a vector of tokens
(define (parse tokens) ; read statements, until hit end of tokens
  (define posn 0)
  (define (peek-token)
    (vector-ref tokens posn))
  (define (get-token)
    (set! posn (+ 1 posn))
    (vector-ref tokens (- posn 1)))
  (define (match type)
    (if (eq? (car (vector-ref tokens posn)) type)
      (set! posn (+ 1 posn))
      (error "Could not match token type" type)))
  ; make it easier to read token parts
  (define type car)
  (define value cadr)
  ;
  ;; left associative read of one or more items with given separators
  (define (read-one-or-more reader separators)
    (let loop ((lft (reader)))
      (let ((next (peek-token)))
        (if (memq (type next) separators)
          (begin (match (type next))
                 (loop (list (retrieve-name (type next)) lft (reader))))
          lft))))
  ;
  ;; read one or two items with given separator
  (define (read-one-or-two reader separators)
    (let* ((lft (reader))
           (next (peek-token)))
      (if (memq (type next) separators)
        (begin (match (type next))
               (list (retrieve-name (type next)) lft (reader)))
        lft)))
  ;
  (define (read-primary)
    (let ((next (get-token)))
      (case (type next)
        ((Identifier Integer)
         next)
        ((LeftParen)
         (let ((v (read-expr)))
           (match 'RightParen)
           v))
        ((Op_add) ; + sign is ignored
         (read-primary))
        ((Op_not)
         (list 'Not (read-primary) '()))
        ((Op_subtract)
         (list 'Negate (read-primary) '()))
        (else
          (error "Unknown primary type")))))
  ;
  (define (read-multiplication-expr) ; *
    (read-one-or-more read-primary '(Op_multiply Op_divide Op_mod)))
  ;
  (define (read-addition-expr) ; *
    (read-one-or-more read-multiplication-expr '(Op_add Op_subtract)))
  ;
  (define (read-relational-expr) ; ?
    (read-one-or-two read-addition-expr
                     '(Op_less Op_lessequal Op_greater Op_greaterequal)))
  ;
  (define (read-equality-expr) ; ?
    (read-one-or-two read-relational-expr '(Op_equal Op_notequal)))
  ;
  (define (read-and-expr) ; *
    (read-one-or-more read-equality-expr '(Op_and)))
  ;
  (define (read-expr) ; *
    (read-one-or-more read-and-expr '(Op_or)))
  ;
  (define (read-prt-list)
    (define (read-print-part)
      (if (eq? (type (peek-token)) 'String)
        (list 'Prts (get-token) '())
        (list 'Prti (read-expr) '())))
    ;
    (do ((tok (read-print-part) (read-print-part))
         (rec '() (list 'Sequence rec tok)))
      ((not (eq? (type (peek-token)) 'Comma))
       (list 'Sequence rec tok))
      (match 'Comma)))
  ;
  (define (read-paren-expr)
    (match 'LeftParen)
    (let ((v (read-expr)))
      (match 'RightParen)
      v))
  ;
  (define (read-stmt)
    (case (type (peek-token))
      ((SemiColon)
       '())
      ((Identifier)
       (let ((id (get-token)))
         (match 'Op_assign)
         (let ((ex (read-expr)))
           (match 'Semicolon)
           (list 'Assign id ex))))
      ((Keyword_while)
       (match 'Keyword_while)
       (let* ((expr (read-paren-expr))
              (stmt (read-stmt)))
         (list 'While expr stmt)))
      ((Keyword_if)
       (match 'Keyword_if)
       (let* ((expr (read-paren-expr))
              (then-part (read-stmt))
              (else-part (if (eq? (type (peek-token)) 'Keyword_else)
                           (begin (match 'Keyword_else)
                                  (read-stmt))
                           '())))
         (list 'If expr (list 'If then-part else-part))))
      ((Keyword_print)
       (match 'Keyword_print)
       (match 'LeftParen)
       (let ((v (read-prt-list)))
         (match 'RightParen)
         (match 'Semicolon)
         v))
      ((Keyword_putc)
       (match 'Keyword_putc)
       (let ((v (read-paren-expr)))
         (match 'Semicolon)
         (list 'Putc v '())))
      ((LeftBrace)
       (match 'LeftBrace)
       (let ((v (read-stmts)))
         (match 'RightBrace)
         v))
      (else
        (error "Unknown token type for statement" (type (peek-token))))))
  ;
  (define (read-stmts)
    (do ((sequence (list 'Sequence '() (read-stmt))
                   (list 'Sequence sequence (read-stmt))))
      ((memq (type (peek-token)) '(End_of_input RightBrace))
       sequence)))
  ;
  (let ((res (read-stmts)))
    (match 'End_of_input)
    res))

;; reads tokens from file, parses and returns the AST
(define (parse-file filename)
  (define (tokenise line)
    (let ((port (open-input-string line)))
      (read port) ; discard line
      (read port) ; discard col
      (let* ((type (read port)) ; read type as symbol
             (val (read port))) ; check for optional value
        (if (eof-object? val)
          (list type)
          (list type val)))))
  ;
  (with-input-from-file
    filename
    (lambda ()
      (do ((line (read-line) (read-line))
           (toks '() (cons (tokenise line) toks)))
        ((eof-object? line)
         (parse (list->vector (reverse toks))))))))

;; Output the AST in flattened format
(define (display-ast ast)
  (cond ((null? ast)
         (display ";\n"))
        ((= 2 (length ast))
         (display (car ast))
         (display #\tab)
         (write (cadr ast)) ; use write to preserve " " on String
         (newline))
        (else
          (display (car ast)) (newline)
          (display-ast (cadr ast))
          (display-ast (cadr (cdr ast))))))

;; read from filename passed on command line
(if (= 2 (length (command-line)))
  (display-ast (parse-file (cadr (command-line))))
  (display "Error: provide program filename\n"))
