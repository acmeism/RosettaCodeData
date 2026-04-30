mp: import 'mathpresso
variables!: make struct! [
    a [double!]
    b [double!]
    r [double!]
]
;; Compile an expression using the struct
expr: mp/compile variables! "r=pow(a,b);"
;; Prepare inputs
data: make variables! [a: 0 b: 0]
;; Evaluate expression
mp/eval :expr :data
;; Print result
print ["Expression result is:" data/r]
