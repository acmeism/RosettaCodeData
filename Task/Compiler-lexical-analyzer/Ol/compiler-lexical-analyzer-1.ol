(import (owl parse))

(define (get-comment)
   (get-either
      (let-parses (
            (_ (get-imm #\*))
            (_ (get-imm #\/)))
         #true)
      (let-parses (
            (_ get-byte)
            (_ (get-comment)))
         #true)))

(define get-whitespace
   (get-any-of
      (get-byte-if (lambda (x) (has? '(#\tab #\newline #\space #\return) x))) ; whitespace
      (let-parses ( ; comment
            (_ (get-imm #\/))
            (_ (get-imm #\*))
            (_ (get-comment)))
         #true)))

(define get-operator
   (let-parses (
         (operator (get-any-of
            (get-word "||" 'Op_or)
            (get-word "&&" 'Op_and)
            (get-word "!=" 'Op_notequal)
            (get-word "==" 'Op_equal)
            (get-word ">=" 'Op_greaterequal)
            (get-word "<=" 'Op_lessequal)

            (get-word "=" 'Op_assign)
            (get-word "!" 'Op_nop)
            (get-word ">" 'Op_greater)
            (get-word "<" 'Op_less)
            (get-word "-" 'Op_subtract)
            (get-word "+" 'Op_add)
            (get-word "%" 'Op_mod)
            (get-word "/" 'Op_divide)
            (get-word "*" 'Op_multiply))))
      (cons 'operator operator)))

(define get-symbol
   (let-parses (
         (symbol (get-any-of
            (get-word "(" 'LeftParen)
            (get-word ")" 'RightParen)
            (get-word "{" 'LeftBrace)
            (get-word "}" 'RightBrace)
            (get-word ";" 'Semicolon)
            (get-word "," 'Comma))))
      (cons 'symbol symbol)))

(define get-keyword
   (let-parses (
         (keyword (get-any-of
            (get-word "if" 'Keyword_if)
            (get-word "else" 'Keyword_else)
            (get-word "while" 'Keyword_while)
            (get-word "print" 'Keyword_print)
            (get-word "putc" 'Keyword_putc))))
      (cons 'keyword keyword)))



(define get-identifier
   (let-parses (
         (lead (get-byte-if              (lambda (x) (or (<= #\a x #\z) (<= #\A x #\Z) (= x #\_)))))
         (tail (get-greedy* (get-byte-if (lambda (x) (or (<= #\a x #\z) (<= #\A x #\Z) (= x #\_) (<= #\0 x #\9)))))))
      (cons 'identifier (bytes->string (cons lead tail)))))

(define get-integer
   (let-parses (
         (main (get-greedy+ (get-byte-if (lambda (x) (<= #\0 x #\9))))) )
      (cons 'integer (string->integer (bytes->string main)))))

(define get-character
   (let-parses (
         (_ (get-imm #\'))
         (char (get-any-of
            (get-word "\\n" #\newline)
            (get-word "\\\\" #\\)
            (get-byte-if (lambda (x) (not (or (eq? x #\') (eq? x #\newline)))))))
         (_ (get-imm #\')) )
      (cons 'character char)))

(define get-string
   (let-parses (
         (_ (get-imm #\")) ;"
         (data (get-greedy* (get-any-of
            (get-word "\\n" #\newline)
            (get-word "\\\\" #\\) ;\"
            (get-byte-if (lambda (x) (not (or (eq? x #\") (eq? x #\newline)))))))) ;", newline
         (_ (get-imm #\")) ) ;"
      (cons 'string (bytes->string data))))

(define get-token
   (let-parses (
         (_ (get-greedy* get-whitespace))
         (token (get-any-of
            get-symbol
            get-keyword
            get-identifier
            get-operator
            get-integer
            get-character
            get-string
         )) )
      token))

(define token-parser
   (let-parses (
         (tokens (get-greedy+ get-token))
         (_ (get-greedy* get-whitespace)))
      tokens))


(define (translate source)
   (let ((stream (try-parse token-parser (str-iter source) #t)))
      (for-each print (car stream))
      (if (null? (cdr stream))
         (print 'End_of_input))))
