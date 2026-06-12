#lang racket

(require syntax/parse/define
         (only-in racket [#%top racket:#%top])
         (for-syntax racket/string))

(define-syntax-parser #%top
  [(_ . x)
   #:do [(define s (symbol->string (syntax-e #'x)))
         (define num (string->number (string-replace s "_" "")))]
   #:when num
   (syntax-parse #'x
     [_ #:fail-when (string-contains? s "__") "invalid multiple consecutive separators"
        #`#,num])]
  [(_ . x) #'(racket:#%top . x)])

1_234_567.89
1_234__567.89
