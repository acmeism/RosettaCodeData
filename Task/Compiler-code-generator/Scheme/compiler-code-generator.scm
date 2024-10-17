(import (scheme base)
        (scheme file)
        (scheme process-context)
        (scheme write)
        (only (srfi 1) delete-duplicates list-index)
        (only (srfi 13) string-delete string-index string-trim))

(define *names* '((Add add) (Subtract sub) (Multiply mul) (Divide div) (Mod mod)
                            (Less lt) (Greater gt) (LessEqual le) (GreaterEqual ge)
                            (Equal eq) (NotEqual ne) (And and) (Or or) (Negate neg)
                            (Not not) (Prts prts) (Prti prti) (Prtc prtc)))

(define (change-name name)
  (if (assq name *names*)
    (cdr (assq name *names*))
    (error "Cannot find name" name)))

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
  (with-input-from-file filename (lambda () (read-expr))))

;; run a three-pass assembler
(define (generate-code ast)
  (define new-address ; create a new unique address - for jump locations
    (let ((count 0))
      (lambda ()
        (set! count (+ 1 count))
        (string->symbol (string-append "loc-" (number->string count))))))
  ; define some names for fields
  (define left cadr)
  (define right (lambda (x) (cadr (cdr x))))
  ;
  (define (extract-values ast)
    (if (null? ast)
      (values '() '())
      (case (car ast)
        ((Integer)
         (values '() '()))
        ((Negate Not Prtc Prti Prts)
         (extract-values (left ast)))
        ((Assign Add Subtract Multiply Divide Mod Less Greater LessEqual GreaterEqual
                 Equal NotEqual And Or If While Sequence)
         (let-values (((a b) (extract-values (left ast)))
                      ((c d) (extract-values (right ast))))
                     (values (delete-duplicates (append a c) string=?)
                             (delete-duplicates (append b d) string=?))))
        ((String)
         (values '() (list (left ast))))
        ((Identifier)
         (values (list (left ast)) '())))))
  ;
  (let-values (((constants strings) (extract-values ast)))
              (define (constant-idx term)
                (list-index (lambda (s) (string=? s term)) constants))
              (define (string-idx term)
                (list-index (lambda (s) (string=? s term)) strings))
              ;
              (define (pass-1 ast asm) ; translates ast into a list of basic operations
                (if (null? ast)
                  asm
                  (case (car ast)
                    ((Integer)
                     (cons (list 'push (left ast)) asm))
                    ((Identifier)
                     (cons (list 'fetch (constant-idx (left ast))) asm))
                    ((String)
                     (cons (list 'push (string-idx (left ast))) asm))
                    ((Assign)
                     (cons (list 'store (constant-idx (left (left ast)))) (pass-1 (right ast) asm)))
                    ((Add Subtract Multiply Divide Mod Less Greater LessEqual GreaterEqual
                          Equal NotEqual And Or) ; binary operators
                     (cons (change-name (car ast))
                           (pass-1 (right ast) (pass-1 (left ast) asm))))
                    ((Negate Not Prtc Prti Prts) ; unary operations
                     (cons (change-name (car ast))
                           (pass-1 (left ast) asm)))
                    ((If)
                     (let ((label-else (new-address))
                           (label-end (new-address)))
                       (if (null? (right (right ast)))
                         (cons (list 'label label-end) ; label for end of if statement
                               (pass-1 (left (right ast)) ; output the 'then block
                                       (cons (list 'jz label-end) ; jump to end when test is false
                                             (pass-1 (left ast) asm))))
                         (cons (list 'label label-end) ; label for end of if statement
                               (pass-1 (right (right ast)) ; output the 'else block
                                       (cons (list 'label label-else)
                                             (cons (list 'jmp label-end) ; jump past 'else, after 'then
                                                   (pass-1 (left (right ast)) ; output the 'then block
                                                           (cons (list 'jz label-else) ; jumpt to else when false
                                                                 (pass-1 (left ast) asm))))))))))
                    ((While)
                     (let ((label-test (new-address))
                           (label-end (new-address)))
                       (cons (list 'label label-end) ; introduce a label for end of while block
                             (cons (list 'jmp label-test) ; jump back to repeat test
                                   (pass-1 (right ast)  ; output the block
                                           (cons (list 'jz label-end) ; test failed, jump around block
                                                 (pass-1 (left ast) ; output the test
                                                         (cons (list 'label label-test) ; introduce a label for test
                                                               asm))))))))
                    ((Sequence)
                     (pass-1 (right ast) (pass-1 (left ast) asm)))
                    (else
                      "Unknown token type"))))
              ;
              (define (pass-2 asm) ; adds addresses and fills in jump locations
                (define (fill-addresses)
                  (let ((addr 0))
                    (map (lambda (instr)
                           (let ((res (cons addr instr)))
                             (unless (eq? (car instr) 'label)
                               (set! addr (+ addr (if (= 1 (length instr)) 1 5))))
                             res))
                         asm)))
                ;
                (define (extract-labels asm)
                  (let ((labels '()))
                    (for-each (lambda (instr)
                                (when (eq? (cadr instr) 'label)
                                  (set! labels (cons (cons (cadr (cdr instr)) (car instr))
                                                     labels))))
                              asm)
                    labels))
                ;
                (define (add-jump-locations asm labels rec)
                  (cond ((null? asm)
                         (reverse rec))
                        ((eq? (cadr (car asm)) 'label) ; ignore the labels
                         (add-jump-locations (cdr asm) labels rec))
                        ((memq (cadr (car asm)) '(jmp jz)) ; replace labels with addresses for jumps
                         (add-jump-locations (cdr asm)
                                             labels
                                             (cons (list (car (car asm)) ; previous address
                                                         (cadr (car asm)) ; previous jump type
                                                         (cdr (assq (cadr (cdar asm)) labels))) ; actual address
                                                   rec)))
                        (else
                          (add-jump-locations (cdr asm) labels (cons (car asm) rec)))))
                ;
                (let ((asm+addr (fill-addresses)))
                  (add-jump-locations asm+addr (extract-labels asm+addr) '())))
              ;
              (define (output-instruction instr)
                   (display (number->string (car instr))) (display #\tab)
                   (display (cadr instr)) (display #\tab)
                (case (cadr instr)
                  ((fetch store)
                   (display "[") (display (number->string (cadr (cdr instr)))) (display "]\n"))
                  ((jmp jz)
                   (display
                     (string-append "("
                                    (number->string (- (cadr (cdr instr)) (car instr) 1))
                                    ")"))
                   (display #\tab)
                   (display (number->string (cadr (cdr instr)))) (newline))
                  ((push)
                   (display (cadr (cdr instr))) (newline))
                  (else
                    (newline))))
              ; generate the code and output to stdout
              (display
                (string-append "Datasize: "
                               (number->string (length constants))
                               " Strings: "
                               (number->string (length strings))))
              (newline)
              (for-each (lambda (str) (display str) (newline))
                        strings)
              (for-each output-instruction
                        (pass-2 (reverse (cons (list 'halt) (pass-1 ast '())))))))

;; read AST from file and output code to stdout
(if (= 2 (length (command-line)))
  (generate-code (read-code (cadr (command-line))))
  (display "Error: pass an ast filename\n"))
