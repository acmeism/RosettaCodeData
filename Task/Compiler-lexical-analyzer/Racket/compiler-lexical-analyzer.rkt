#lang racket
(require parser-tools/lex)

(define-lex-abbrevs
  [letter         (union (char-range #\a #\z) (char-range #\A #\Z))]
  [digit          (char-range #\0 #\9)]
  [underscore     #\_]
  [identifier     (concatenation (union letter underscore)
                                 (repetition 0 +inf.0 (union letter digit underscore)))]
  [integer        (repetition 1 +inf.0 digit)]
  [char-content   (char-complement (char-set "'\n"))]
  [char-literal   (union (concatenation #\' char-content #\')
                         "'\\n'" "'\\\\'")]
  [string-content (union (char-complement (char-set "\"\n")))]
  [string-literal (union (concatenation #\" (repetition 0 +inf.0 string-content) #\")
                         "\"\\n\"" "\"\\\\\"")]
  [keyword        (union "if" "else" "while" "print" "putc")]
  [operator       (union "*" "/" "%" "+" "-" "-"
                         "<" "<=" ">" ">=" "==" "!="
                         "!" "=" "&&" "||")]
  [symbol         (union "(" ")" "{" "}" ";" ",")]
  [comment        (concatenation "/*" (complement (concatenation any-string "*/" any-string)) "*/")])

(define operators-ht
  (hash "*"  'Op_multiply "/"  'Op_divide    "%" 'Op_mod      "+"  'Op_add           "-"  'Op_subtract
        "<"  'Op_less     "<=" 'Op_lessequal ">" 'Op_greater  ">=" 'Op_greaterequal "==" 'Op_equal
        "!=" 'Op_notequal "!"  'Op_not       "=" 'Op_assign   "&&" 'Op_and          "||" 'Op_or))

(define symbols-ht
  (hash "(" 'LeftParen  ")" 'RightParen
        "{" 'LeftBrace  "}" 'RightBrace
        ";" 'Semicolon  "," 'Comma))

(define (lexeme->keyword  l) (string->symbol (~a "Keyword_" l)))
(define (lexeme->operator l) (hash-ref operators-ht l))
(define (lexeme->symbol   l) (hash-ref symbols-ht   l))
(define (lexeme->char     l) (match l
                               ["'\\\\'" #\\]
                               ["'\\n'"  #\newline]
                               [_       (string-ref l 1)]))

(define (token name [value #f])
  (cons name (if value (list value) '())))

(define (lex ip)
  (port-count-lines! ip)
  (define my-lexer
    (lexer-src-pos
     [integer        (token 'Integer (string->number lexeme))]
     [char-literal   (token 'Integer (char->integer (lexeme->char lexeme)))]
     [string-literal (token 'String  lexeme)]
     [keyword        (token (lexeme->keyword  lexeme))]
     [operator       (token (lexeme->operator lexeme))]
     [symbol         (token (lexeme->symbol   lexeme))]
     [comment        #f]
     [whitespace     #f]
     [identifier     (token 'Identifier lexeme)]
     [(eof)          (token 'End_of_input)]))
  (define (next-token) (my-lexer ip))
  next-token)

(define (string->tokens s)
  (port->tokens (open-input-string s)))

(define (port->tokens ip)
  (define next-token (lex ip))
  (let loop ()
    (match (next-token)
      [(position-token t (position offset line col) _)
       (set! col (+ col 1)) ; output is 1-based
       (match t
         [#f                   (loop)] ; skip whitespace/comments
         [(list 'End_of_input) (list (list line col 'End_of_input))]
         [(list name value)    (cons (list line col name value) (loop))]
         [(list name)          (cons (list line col name)       (loop))]
         [_ (error)])])))

(define test1 #<<TEST
/*
  Hello world
 */
print("Hello, World!\n");

TEST
)

(define test2 #<<TEST
/*
  Show Ident and Integers
 */
phoenix_number = 142857;
print(phoenix_number, "\n");

TEST
  )

(define test3 #<<TEST
/*
  All lexical tokens - not syntactically correct, but that will
  have to wait until syntax analysis
 */
/* Print   */  print    /* Sub     */  -
/* Putc    */  putc     /* Lss     */  <
/* If      */  if       /* Gtr     */  >
/* Else    */  else     /* Leq     */  <=
/* While   */  while    /* Geq     */  >=
/* Lbrace  */  {        /* Eq      */  ==
/* Rbrace  */  }        /* Neq     */  !=
/* Lparen  */  (        /* And     */  &&
/* Rparen  */  )        /* Or      */  ||
/* Uminus  */  -        /* Semi    */  ;
/* Not     */  !        /* Comma   */  ,
/* Mul     */  *        /* Assign  */  =
/* Div     */  /        /* Integer */  42
/* Mod     */  %        /* String  */  "String literal"
/* Add     */  +        /* Ident   */  variable_name
/* character literal */  '\n'
/* character literal */  '\\'
/* character literal */  ' '
TEST
  )

(define test4 #<<TEST
/*** test printing, embedded \n and comments with lots of '*' ***/
print(42);
print("\nHello World\nGood Bye\nok\n");
print("Print a slash n - \\n.\n");
TEST
  )

(define test5 #<<TEST
count = 1;
while (count < 10) {
    print("count is: ", count, "\n");
    count = count + 1;
}
TEST
  )

(define (display-tokens ts)
  (for ([t ts])
    (for ([x t])
      (display x) (display "\t\t"))
    (newline)))

"TEST 1"
(display-tokens (string->tokens test1))
"TEST 2"
(display-tokens (string->tokens test2))
"TEST 3"
(display-tokens (string->tokens test3))
"TEST 4"
(display-tokens (string->tokens test4))
"TEST 5"
(display-tokens (string->tokens test5))
