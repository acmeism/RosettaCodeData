; call a function (procedure) with no arguments:
(foo)

; call a function (procedure) with arguments:
(foo bar baz)
; the first symbol after "(" is the name of the function
; the other symbols are the arguments

; call a function on a list of arguments formed at run time:
(apply foo bar)

; In a REPL, the return value will be printed.
; In other contexts, it can be fed as argument into a further function:
(foo (bar baz))
; this calls bar on the argument baz and then calls foo on the return value

; or it can simply be discarded
(foo bar)
; nothing is done with the return value
