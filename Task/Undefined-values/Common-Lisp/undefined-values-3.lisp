  (defvar *dyn*)  ;; special, no binding

  (let (*dyn*     ;; locally scoped override, value is nil
        lex)      ;; lexical, value is nil
    (list (boundp '*dyn*) *dyn* (boundp 'lex) lex))         -> (T NIL NIL NIL)

  (boundp '*global*) -> NIL
