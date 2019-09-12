; note: sign "==>" indicates expected output

;;; Calling a function that requires no arguments
(define (no-args-function)
   (print "ok."))

(no-args-function)
; ==> ok.


;;; Calling a function with a fixed number of arguments
(define (two-args-function a b)
   (print "a: " a)
   (print "b: " b))

(two-args-function 8 13)
; ==> a: 8
; ==> b: 13


;;; Calling a function with optional arguments
(define (optional-args-function a . args)
   (print "a: " a)
   (if (null? args)
      (print "no optional arguments"))
   (if (less? 0 (length args))
      (print "b: " (car args)))
   (if (less? 1 (length args))
      (print "c: " (cadr args)))
   ; etc...
)

(optional-args-function 3)
; ==> a: 3
; ==> no optional arguments
(optional-args-function 3 8)
; ==> a: 3
; ==> b: 8
(optional-args-function 3 8 13)
; ==> a: 3
; ==> b: 8
; ==> c: 13
(optional-args-function 3 8 13 77)
; ==> a: 3
; ==> b: 8
; ==> c: 13


;;; Calling a function with a variable number of arguments
; /same as optional arguments


;;; Calling a function with named arguments
; /no named arguments "from the box" is provided, but it can be easily simulated using builtin associative arrays (named "ff")
(define (named-args-function args)
   (print "a: " (get args 'a 8)) ; 8 is default value if no variable value given
   (print "b: " (get args 'b 13)); same as above
)

(named-args-function #empty)
; ==> a: 8
; ==> b: 13
(named-args-function (list->ff '((a . 3))))
; ==> a: 3
; ==> b: 13
; or nicer (and shorter) form available from ol version 2.1
(named-args-function '{(a . 3)})
; ==> a: 3
; ==> b: 13
(named-args-function '{(b . 7)})
; ==> a: 8
; ==> b: 7
(named-args-function '{(a . 3) (b . 7)})
; ==> a: 3
; ==> b: 7


;;; Using a function in first-class context within an expression
(define (first-class-arg-function arg a b)
   (print (arg a b))
)

(first-class-arg-function + 2 3)
; ==> 5
(first-class-arg-function - 2 3)
; ==> -1

;;; Using a function in statement context
(let ((function (lambda (x) (* x x))))
   (print (function 4))
; ==> 16
;(print (function 4))
; ==> What is 'function'?

;;; Obtaining the return value of a function
(define (return-value-function)
   (print "ok.")
   123)

(let ((result (return-value-function)))
   (print result))
; ==> ok.
; ==> 123

;;; Obtaining the return value of a function while breaking the function execution (for example infinite loop)
(print
   (call/cc (lambda (return)
      (let loop ((n 0))
         (if (eq? n 100)
            (return (* n n)))
         (loop (+ n 1))))))) ; this is infinite loop
; ==> 10000


;;; Is partial application possible and how
(define (make-partial-function n)
   (lambda (x y)
      (print (n x y)))
)

(define plus (make-partial-function +))
(define minus (make-partial-function -))

(plus 2 3)
; ==> 5
(minus 2 3)
; ==> -1

;;; Distinguishing built-in functions and user-defined functions
; ol has no builtin functions but only eight builtin forms: quote, values, lambda, setq, letq, ifeq, either, values-apply.
; all other functions is "user-defined", and some of them defined in base library, for example (scheme core) defines if, or, and, zero?, length, append...

;;; Distinguishing subroutines and functions
; Both subroutines and functions is a functions in Ol.
; Btw, the "subroutine" has a different meaning in Ol - the special function that executes simultaneously in own context. The intersubroutine messaging mechanism is provided, sure.

;;; Stating whether arguments are passed by value or by reference
; The values in Ol always passed as values and objects always passed as references. If you want to pass an object copy - make a copy by yourself.
