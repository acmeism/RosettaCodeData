  ;; assumption: none of these variables initially exist

  (defvar *x*)    ;; variable exists now, but has no value
  (defvar *y* 42) ;; variable exists now, and has a value

  (special-variable-p '*x*) -> T  ;; Symbol *x* names a special variable
  (boundp '*x*) -> NIL            ;; *x* has no binding
  (boundp '*y*) -> T

  (special-variable-p '*z*) -> NIL ;; *z* does not name a special variable
