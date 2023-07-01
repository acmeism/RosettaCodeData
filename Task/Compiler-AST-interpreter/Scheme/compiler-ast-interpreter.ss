(import (scheme base)
        (scheme file)
        (scheme process-context)
        (scheme write)
        (only (srfi 13) string-delete string-index string-trim))

;; Mappings from operation symbols to internal procedures.
;; We define operations appropriate to virtual machine:
;; e.g. division must return an int, not a rational
;; boolean values are treated as numbers: 0 is false, other is true
(define *unary-ops*
  (list (cons 'Negate (lambda (a) (- a)))
        (cons 'Not (lambda (a) (if (zero? a) 1 0)))))
(define *binary-ops*
  (let ((number-comp (lambda (op) (lambda (a b) (if (op a b) 1 0)))))
    (list (cons 'Add +)
          (cons 'Subtract -)
          (cons 'Multiply *)
          (cons 'Divide (lambda (a b) (truncate (/ a b)))) ; int division
          (cons 'Mod modulo)
          (cons 'Less (number-comp <))
          (cons 'Greater (number-comp >))
          (cons 'LessEqual (number-comp <=))
          (cons 'GreaterEqual (number-comp >=))
          (cons 'Equal (lambda (a b) (if (= a b) 1 0)))
          (cons 'NotEqual (lambda (a b) (if (= a b) 0 1)))
          (cons 'And (lambda (a b) ; make "and" work on numbers
                       (if (and (not (zero? a)) (not (zero? b))) 1 0)))
          (cons 'Or (lambda (a b) ; make "or" work on numbers
                      (if (or (not (zero? a)) (not (zero? b))) 1 0))))))

;; Read AST from given filename
;; - return as an s-expression
(define (read-code filename)
  (define (read-expr)
    (let ((line (string-trim (read-line))))
      (if (string=? line ";")
        '()
        (let ((space (string-index line #\space)))
          (if space
            (list (string->symbol (string-trim (substring line 0 space)))
                  (string-trim (substring line space (string-length line))))
            (list (string->symbol line) (read-expr) (read-expr)))))))
  ;
  (with-input-from-file
    filename
    (lambda ()
      (read-expr))))

;; interpret AST provided as an s-expression
(define run-program
  (let ((env '())) ; env is an association list for variable names
    (lambda (expr)
      (define (tidy-string str)
        (string-delete ; remove any quote marks
          #\" ; " (to appease Rosetta code's syntax highlighter)
          (list->string
            (let loop ((chars (string->list str))) ; replace newlines, obeying \\n
              (cond ((< (length chars) 2) ; finished list
                     chars)
                    ((and (>= (length chars) 3) ; preserve \\n
                          (char=? #\\ (car chars))
                          (char=? #\\ (cadr chars))
                          (char=? #\n (cadr (cdr chars))))
                     (cons (car chars)
                           (cons (cadr chars)
                                 (cons (cadr (cdr chars))
                                       (loop (cdr (cdr (cdr chars))))))))
                    ((and (char=? #\\ (car chars)) ; replace \n with newline
                          (char=? #\n (cadr chars)))
                     (cons #\newline (loop (cdr (cdr chars)))))
                    (else ; keep char and look further
                      (cons (car chars) (loop (cdr chars)))))))))
      ; define some more meaningful names for fields
      (define left cadr)
      (define right (lambda (x) (cadr (cdr x))))
      ;
      (if (null? expr)
        '()
        (case (car expr) ; interpret AST from the head node
          ((Integer)
           (string->number (left expr)))
          ((Identifier)
           (let ((val (assq (string->symbol (left expr)) env)))
             (if val
               (cdr val)
               (error "Variable not in environment"))))
          ((String)
           (left expr))
          ((Assign)
           (set! env (cons (cons (string->symbol (left (left expr)))
                                 (run-program (right expr)))
                           env)))
          ((Add Subtract Multiply Divide Mod
                Less Greater LessEqual GreaterEqual Equal NotEqual
                And Or)
           (let ((binop (assq (car expr) *binary-ops*)))
             (if binop
               ((cdr binop) (run-program (left expr))
                            (run-program (right expr)))
               (error "Could not find binary operator"))))
          ((Negate Not)
           (let ((unaryop (assq (car expr) *unary-ops*)))
             (if unaryop
               ((cdr unaryop) (run-program (left expr)))
               (error "Could not find unary operator"))))
          ((If)
           (if (not (zero? (run-program (left expr)))) ; 0 means false
             (run-program (left (right expr)))
             (run-program (right (right expr))))
           '())
          ((While)
           (let loop ()
             (unless (zero? (run-program (left expr)))
               (run-program (right expr))
               (loop)))
           '())
          ((Prtc)
           (display (integer->char (run-program (left expr))))
           '())
          ((Prti)
           (display (run-program (left expr)))
           '())
          ((Prts)
           (display (tidy-string (run-program (left expr))))
           '())
          ((Sequence)
           (run-program (left expr))
           (run-program (right expr))
           '())
          (else
            (error "Unknown node type")))))))

;; read AST from file and interpret, from filename passed on command line
(if (= 2 (length (command-line)))
  (run-program (read-code (cadr (command-line))))
  (display "Error: pass an ast filename\n"))
