(define (string-reverse string)
    (list->string (reverse (string->list string))))

(string-reverse "ghij")
    → jihg
(string-reverse "un roc lamina l animal cornu")
    → unroc lamina l animal cor nu
