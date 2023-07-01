(import (scheme base)
        (scheme char)
        (scheme cxr)
        (scheme write)
        (srfi 1 lists))

;; convert a string into a list of tokens
(define (string->tokens str)
  (define (next-token chars)
    (cond ((member (car chars) (list #\+ #\- #\* #\/) char=?)
           (values (cdr chars)
                   (cdr (assq (car chars) ; convert char for op into op procedure, using a look up list
                              (list (cons #\+ +) (cons #\- -) (cons #\* *) (cons #\/ /))))))
          ((member (car chars) (list #\( #\)) char=?)
           (values (cdr chars)
                   (if (char=? (car chars) #\()
                     'open
                     'close)))
          (else ; read a multi-digit positive integer
            (let loop ((rem chars)
                       (res 0))
              (if (and (not (null? rem))
                       (char-numeric? (car rem)))
                (loop (cdr rem)
                      (+ (* res 10)
                         (- (char->integer (car rem))
                            (char->integer #\0))))
                (values rem
                        res))))))
  ;
  (let loop ((chars (remove char-whitespace? (string->list str)))
             (tokens '()))
    (if (null? chars)
      (reverse tokens)
      (let-values (((remaining-chars token) (next-token chars)))
                  (loop remaining-chars
                        (cons token tokens))))))

;; turn list of tokens into an AST
;; -- using recursive descent parsing to obey laws of precedence
(define (parse tokens)
  (define (parse-factor tokens)
    (if (number? (car tokens))
      (values (car tokens) (cdr tokens))
      (let-values (((expr rem) (parse-expr (cdr tokens))))
                  (values expr (cdr rem)))))
  (define (parse-term tokens)
    (let-values (((left-expr rem) (parse-factor tokens)))
                (if (and (not (null? rem))
                         (member (car rem) (list * /)))
                  (let-values (((right-expr remr) (parse-term (cdr rem))))
                              (values (list (car rem) left-expr right-expr)
                                      remr))
                  (values left-expr rem))))
  (define (parse-part tokens)
    (let-values (((left-expr rem) (parse-term tokens)))
                (if (and (not (null? rem))
                         (member (car rem) (list + -)))
                  (let-values (((right-expr remr) (parse-part (cdr rem))))
                              (values (list (car rem) left-expr right-expr)
                                      remr))
                  (values left-expr rem))))
  (define (parse-expr tokens)
    (let-values (((expr rem) (parse-part tokens)))
                (values expr rem)))
  ;
  (let-values (((expr rem) (parse-expr tokens)))
                (if (null? rem)
                  expr
                  (error "Misformed expression"))))

;; evaluate the AST, returning a number
(define (eval-expression ast)
  (cond ((number? ast)
         ast)
        ((member (car ast) (list + - * /))
         ((car ast)
          (eval-expression (cadr ast))
          (eval-expression (caddr ast))))
        (else
          (error "Misformed expression"))))

;; parse and evaluate the given string
(define (interpret str)
  (eval-expression (parse (string->tokens str))))

;; running some examples
(for-each
  (lambda (str)
    (display
      (string-append str
                     " => "
                     (number->string (interpret str))))
    (newline))
  '("1 + 2" "20+4*5" "1/2+5*(6-3)" "(1+3)/4-1" "(1 - 5) * 2 / (20 + 1)"))
