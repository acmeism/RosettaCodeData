(define (multiply a b) (* a b)) → multiply ;; (1)
(multiply 1/3 666) → 222

;; a function is a lambda definition :
multiply
     → (λ (_a _b) (#* _a _b))

;; The following is the same as (1) :
(define multiply (lambda(a b) (* a b)))
multiply
    → (🔒 λ (_a _b) (#* _a _b)) ;; a closure


;; a function may be compiled
(lib 'compile)
(compile 'multiply "-float-verbose")
    →
💡 [0]     compiling _🔶_multiply ((#* _a _b))
;; object code (javascript) :
var ref,top = _blocks[_topblock];
/* */return (
/* */(_stack[top] *_stack[1 + top])
/* */);

multiply  → (λ (_a _b) (#🔶_multiply)) ;; compiled function
