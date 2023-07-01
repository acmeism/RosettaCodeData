define-syntax-rule
    (set!-string-prepend a before)
    (set! a (string-append before a)))
   → #syntax:set!-string-prepend

(define name "Presley")
    → name
(set!-string-prepend name "Elvis ")
name
    → "Elvis Presley"
