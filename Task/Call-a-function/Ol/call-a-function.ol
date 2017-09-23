; note: sign "==>" indicates expected output

;;; Calling a function that requires no arguments
(define (no-args-function)
   (print "ok."))
)

(no-args-function)
; ==> ok.


;;; Calling a function with a fixed number of arguments
(define (two-args-function a b)
   (print "a: " a)
   (print "b: " b))
)

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
   ; etc.
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
; /no named arguments "from the box" provided, but it can be simulated using builtin maps (named "ff")
(define (named-args-function args)
   (print "a: " (get args 'a 8))
   (print "b: " (get args 'b 13))
)

(named-args-function #empty)
; ==> a: 8
; ==> b: 13
(named-args-function (list->ff '((a . 3))))
; ==> a: 3
; ==> b: 13
(named-args-function (list->ff '((b . 7))))
; ==> a: 8
; ==> b: 7
(named-args-function (list->ff '((a . 3) (b . 7))))
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


;;; Obtaining the return value of a function
(define (return-value-function)
   (print "ok.")
   123)

(let ((result (return-value-function)))
   (print result))
; ==> ok.
; ==> 123
; actually


;;; Is partial application possible and how
(define (make-partial-function n)
   (lambda (x y)
      (print (n x y)))
)

(define plus (make-partial-function +))
(plus 2 3)
; ==> 5
(define minus (make-partial-function -))
(minus 2 3)
; ==> -1


; TBD:
;;; Using a function in statement context
;;; Using a function in first-class context within an expression
;;; Obtaining the return value of a function
;;; Distinguishing built-in functions and user-defined functions
;;; Distinguishing subroutines and functions
;;; Stating whether arguments are passed by value or by reference
