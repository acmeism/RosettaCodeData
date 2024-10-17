; Syntax that implements a C-like enum; items without assignment take next value.
; Form: (enum <name> <item>...)
; Where <name> is a symbol that will be the name of the enum; <item> are one or
; more expressions that are either symbols or lists of symbol and integer value.
; The symbols are bound to the values.  If a value is not given, then the next
; integer after the one bound to the previous symbol is used (starting at 0).
; The <name> itself is bound to an a-list of the item symbols and their values.

(define-syntax enum
  (lambda (x)
    (syntax-case x ()
      ((_ name itm1 itm2 ...)
        (identifier? (syntax name))
        (syntax
          (begin
            (define name '())
            (enum-help name 0 itm1 itm2 ...)))))))

; Helper for (enum) syntax, above.  Do not call directly!

(define-syntax enum-help
  (lambda (x)
    (syntax-case x ()
      ((_ name nxint)
        (syntax (void)))
      ((_ name nxint (sym val) rest ...)
        (and (identifier? (syntax sym))
             (integer? (syntax-object->datum (syntax val))))
        (syntax
          (begin
            (define sym val)
            (set! name (cons (cons 'sym val) name))
            (enum-help name (1+ val) rest ...))))
      ((_ name nxint sym rest ...)
        (identifier? (syntax sym))
        (syntax
          (begin
            (define sym nxint)
            (set! name (cons (cons 'sym nxint) name))
            (enum-help name (1+ nxint) rest ...)))))))
