(use srfi-13) ;; string functions
(use srfi-14) ;; character sets
(use file.util)

;; Increment a value in an association list.
(define-syntax ainc!
  (syntax-rules ()
    [(_ alist key val func default)
     (let ((pair (assoc key alist)))
       (if pair
         (set-cdr! pair (func val (cdr pair)))
         (set! alist (cons (cons key (func val default)) alist))))]
    [(_ alist key val func)
     (ainc! alist key val func 0)]
    [(_ alist key val)
     (ainc! alist key val +)]
    [(_ alist key)
     (ainc! alist key 1)]))

(define *table* '())

(define (process-line line)
  (dolist (word
            (string-tokenize (string-upcase line) char-set:letter))
    (ainc! *table* word)))

(define (foo filename)
  (set! *table* '())
  (dolist (line (file->string-list filename))
    (process-line line)))

(time (foo "Alice.txt"))
; user   3.219 [seconds]

(define *result* (sort *table* > cdr))

(take *result* 10)

(("THE" . 1818) ("AND" . 940) ("TO" . 809) ("A" . 690) ("OF" . 631)
 ("IT" . 610) ("SHE" . 553) ("I" . 545) ("YOU" . 481) ("SAID" . 462))
