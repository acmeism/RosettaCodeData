(require (for-syntax syntax/parse))

(define-syntax list-when
  (syntax-parser
    [(_ test:expr body:expr)
     #'(if test
           body
           null)]))
