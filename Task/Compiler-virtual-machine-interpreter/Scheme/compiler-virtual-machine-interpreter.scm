(import (scheme base)
        (scheme char)
        (scheme file)
        (scheme process-context)
        (scheme write)
        (only (srfi 13) string-contains string-delete string-filter
              string-replace string-tokenize))

(define *word-size* 4)

;; Mappings from operation symbols to internal procedures.
;; We define operations appropriate to virtual machine:
;; e.g. division must return an int, not a rational
;; boolean values are treated as numbers: 0 is false, other is true
(define *unary-ops*
  (list (cons 'neg (lambda (a) (- a)))
        (cons 'not (lambda (a) (if (zero? a) 1 0)))))
(define *binary-ops*
  (let ((number-comp (lambda (op) (lambda (a b) (if (op a b) 1 0)))))
    (list (cons 'add +)
          (cons 'sub -)
          (cons 'mul *)
          (cons 'div (lambda (a b) (truncate (/ a b)))) ; int division
          (cons 'mod modulo)
          (cons 'lt (number-comp <))
          (cons 'gt (number-comp >))
          (cons 'le (number-comp <=))
          (cons 'ge (number-comp >=))
          (cons 'eq (lambda (a b) (if (= a b) 1 0)))
          (cons 'ne (lambda (a b) (if (= a b) 0 1)))
          (cons 'and (lambda (a b) ; make "and" work on numbers
                       (if (and (not (zero? a)) (not (zero? b))) 1 0)))
          (cons 'or (lambda (a b) ; make "or" work on numbers
                      (if (or (not (zero? a)) (not (zero? b))) 1 0))))))

;; read information from file, returning vectors for data and strings
;; and a list of the code instructions
(define (read-code filename)
  (define (setup-definitions str)
    (values ; return vectors for (data strings) of required size
      (make-vector (string->number (list-ref str 1)) #f)
      (make-vector (string->number (list-ref str 3)) #f)))
  (define (read-strings strings) ; read constant strings into data structure
    (define (replace-newlines chars) ; replace newlines, obeying \\n
      (cond ((< (length chars) 2) ; finished list
             chars)
            ((and (>= (length chars) 3) ; preserve \\n
                  (char=? #\\ (car chars))
                  (char=? #\\ (cadr chars))
                  (char=? #\n (cadr (cdr chars))))
             (cons (car chars)
                   (cons (cadr chars)
                         (cons (cadr (cdr chars))
                               (replace-newlines (cdr (cdr (cdr chars))))))))
            ((and (char=? #\\ (car chars)) ; replace \n with newline
                  (char=? #\n (cadr chars)))
             (cons #\newline (replace-newlines (cdr (cdr chars)))))
            (else ; keep char and look further
              (cons (car chars) (replace-newlines (cdr chars))))))
    (define (tidy-string str) ; remove quotes, map newlines to actual newlines
      (list->string
        (replace-newlines
          (string->list
            (string-delete #\" str))))) ; " (needed to satisfy rosettacode's scheme syntax highlighter)
    ;
    (do ((i 0 (+ i 1)))
      ((= i (vector-length strings)) )
      (vector-set! strings i (tidy-string (read-line)))))
  (define (read-code)
    (define (cleanup-code opn) ; tidy instructions, parsing numbers
      (let ((addr (string->number (car opn)))
            (instr (string->symbol (cadr opn))))
        (cond ((= 2 (length opn))
               (list addr instr))
              ((= 3 (length opn))
               (list addr
                     instr
                     (string->number
                       (string-filter char-numeric? (list-ref opn 2)))))
              (else ; assume length 4, jump instructions
                (list addr instr (string->number (list-ref opn 3)))))))
    ;
    (let loop ((result '()))
      (let ((line (read-line)))
        (if (eof-object? line)
          (reverse (map cleanup-code result))
          (loop (cons (string-tokenize line) result))))))
  ;
  (with-input-from-file
    filename
    (lambda ()
      (let-values (((data strings)
                    (setup-definitions (string-tokenize (read-line)))))
                  (read-strings strings)
                  (values data
                          strings
                          (read-code))))))

;; run the virtual machine
(define (run-program data strings code)
  (define (get-instruction n)
    (if (assq n code)
      (cdr (assq n code))
      (error "Could not find instruction")))
  ;
  (let loop ((stack '())
             (pc 0))
    (let ((op (get-instruction pc)))
      (case (car op)
        ((fetch)
         (loop (cons (vector-ref data (cadr op)) stack)
               (+ pc 1 *word-size*)))
        ((store)
         (vector-set! data (cadr op) (car stack))
         (loop (cdr stack)
               (+ pc 1 *word-size*)))
        ((push)
         (loop (cons (cadr op) stack)
               (+ pc 1 *word-size*)))
        ((add sub mul div mod lt gt le eq ne and or)
         (let ((instr (assq (car op) *binary-ops*)))
           (if instr
             (loop (cons ((cdr instr) (cadr stack) ; replace top two with result
                                      (car stack))
                         (cdr (cdr stack)))
                   (+ pc 1))
             (error "Unknown binary operation"))))
        ((neg not)
         (let ((instr (assq (car op) *unary-ops*)))
           (if instr
             (loop (cons ((cdr instr) (car stack)) ; replace top with result
                         (cdr stack))
                   (+ pc 1))
             (error "Unknown unary operation"))))
        ((jmp)
         (loop stack
               (cadr op)))
        ((jz)
         (loop (cdr stack)
               (if (zero? (car stack))
                 (cadr op)
                 (+ pc 1 *word-size*))))
        ((prtc)
         (display (integer->char (car stack)))
         (loop (cdr stack)
               (+ pc 1)))
        ((prti)
         (display (car stack))
         (loop (cdr stack)
               (+ pc 1)))
        ((prts)
         (display (vector-ref strings (car stack)))
         (loop (cdr stack)
               (+ pc 1)))
        ((halt)
         #t)))))

;; create and run virtual machine from filename passed on command line
(if (= 2 (length (command-line)))
  (let-values (((data strings code) (read-code (cadr (command-line)))))
              (run-program data strings code))
  (display "Error: pass a .asm filename\n"))
