(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(define-library (suspendable-procedures)

  (export &fail failure? success? suspend fail-forever
          make-generator-procedure)

  (import (scheme base))

  (begin

    (define-record-type <&fail>
      (make-the-one-unique-&fail-that-you-must-not-make-twice)
      do-not-use-this:&fail?)

    (define &fail
      (make-the-one-unique-&fail-that-you-must-not-make-twice))

    (define (failure? f) (eq? f &fail))
    (define (success? f) (not (failure? f)))
    (define *suspend* (make-parameter (lambda (x) x)))
    (define (suspend v) ((*suspend*) v))
    (define (fail-forever)
      (let loop ()
        (suspend &fail)
        (loop)))

    (define (make-generator-procedure thunk)
      ;; This is for making a suspendable procedure that takes no
      ;; arguments when resumed. The result is a simple generator of
      ;; values.
      (define (next-run return)
        (define (my-suspend v)
          (set! return (call/cc (lambda (resumption-point)
                                  (set! next-run resumption-point)
                                  (return v)))))
        (parameterize ((*suspend* my-suspend))
          (suspend (thunk))
          (fail-forever)))
      (lambda () (call/cc next-run)))

    )) ;; end library (suspendable-procedures)

(define-library (avl-trees)
  ;;
  ;; Persistent (that is, ‘immutable’) AVL trees for R7RS Scheme.
  ;;
  ;; References:
  ;;
  ;;   * Niklaus Wirth, 1976. Algorithms + Data Structures =
  ;;     Programs. Prentice-Hall, Englewood Cliffs, New Jersey.
  ;;
  ;;   * Niklaus Wirth, 2004. Algorithms and Data Structures. Updated
  ;;     by Fyodor Tkachov, 2014.
  ;;

  (export avl-make-generator)
  (export avl avl? avl-empty? avl-insert avl-search-values)
  (export avl-check-usage)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (scheme process-context))
  (import (scheme write))
  (import (suspendable-procedures))

  (begin

    (define-syntax avl-check-usage
      (syntax-rules ()
        ((_ pred msg)
         (or pred (usage-error msg)))))

    (define-record-type <avl>
      (%avl key data bal left right)
      avl?
      (key %key)
      (data %data)
      (bal %bal)
      (left %left)
      (right %right))

    (define avl-make-generator
      (case-lambda
        ((tree) (avl-make-generator tree 1))
        ((tree direction)
         (if (negative? direction)
             (make-generator-procedure
              (lambda ()
                (define (traverse p)
                  (unless (or (not p) (avl-empty? p))
                    (traverse (%right p))
                    (suspend (cons (%key p) (%data p)))
                    (traverse (%left p)))
                  &fail)
                (traverse tree)))
             (make-generator-procedure
              (lambda ()
                (define (traverse p)
                  (unless (or (not p) (avl-empty? p))
                    (traverse (%left p))
                    (suspend (cons (%key p) (%data p)))
                    (traverse (%right p)))
                  &fail)
                (traverse tree)))))))

    (define (avl) (%avl #f #f #f #f #f))

    (define (avl-empty? tree)
      (avl-check-usage
       (avl? tree)
       "avl-empty? expects an AVL tree as argument")
      (not (%bal tree)))

    (define (avl-search-values pred<? tree key)
      (define (search p)
        (if (not p)
            (values #f #f)
            (let ((k (%key p)))
              (cond ((pred<? key k) (search (%left p)))
                    ((pred<? k key) (search (%right p)))
                    (else (values (%data p) #t))))))
      (avl-check-usage
       (procedure? pred<?)
       "avl-search-values expects a procedure as first argument")
      (if (avl-empty? tree)
          (values #f #f)
          (search tree)))

    (define (avl-insert pred<? tree key data)
      (define (search p fix-balance?)
        (cond
         ((not p)
          (values (%avl key data 0 #f #f) #t))
         ((pred<? key (%key p))
          (let-values (((p1 fix-balance?)
                        (search (%left p) fix-balance?)))
            (cond
             ((not fix-balance?)
              (let ((p^ (%avl (%key p) (%data p) (%bal p)
                              p1 (%right p))))
                (values p^ #f)))
             (else
              (case (%bal p)
                ((1)
                 (let ((p^ (%avl (%key p) (%data p) 0
                                 p1 (%right p))))
                   (values p^ #f)))
                ((0)
                 (let ((p^ (%avl (%key p) (%data p) -1
                                 p1 (%right p))))
                   (values p^ fix-balance?)))
                ((-1)
                 (case (%bal p1)
                   ((-1)
                    (let* ((p^ (%avl (%key p) (%data p) 0
                                     (%right p1) (%right p)))
                           (p1^ (%avl (%key p1) (%data p1) 0
                                      (%left p1) p^)))
                      (values p1^ #f)))
                   ((0 1)
                    (let* ((p2 (%right p1))
                           (bal2 (%bal p2))
                           (p^ (%avl (%key p) (%data p)
                                     (- (min bal2 0))
                                     (%right p2) (%right p)))
                           (p1^ (%avl (%key p1) (%data p1)
                                      (- (max bal2 0))
                                      (%left p1) (%left p2)))
                           (p2^ (%avl (%key p2) (%data p2) 0
                                      p1^ p^)))
                      (values p2^ #f)))
                   (else (internal-error))))
                (else (internal-error)))))))

         ((pred<? (%key p) key)
          (let-values (((p1 fix-balance?)
                        (search (%right p) fix-balance?)))
            (cond
             ((not fix-balance?)
              (let ((p^ (%avl (%key p) (%data p) (%bal p)
                              (%left p) p1)))
                (values p^ #f)))
             (else
              (case (%bal p)
                ((-1)
                 (let ((p^ (%avl (%key p) (%data p) 0
                                 (%left p) p1)))
                   (values p^ #f)))
                ((0)
                 (let ((p^ (%avl (%key p) (%data p) 1
                                 (%left p) p1)))
                   (values p^ fix-balance?)))
                ((1)
                 (case (%bal p1)
                   ((1)
                    (let* ((p^ (%avl (%key p) (%data p) 0
                                     (%left p) (%left p1)))
                           (p1^ (%avl (%key p1) (%data p1) 0
                                      p^ (%right p1))))
                      (values p1^ #f)))
                   ((-1 0)
                    (let* ((p2 (%left p1))
                           (bal2 (%bal p2))
                           (p^ (%avl (%key p) (%data p)
                                     (- (max bal2 0))
                                     (%left p) (%left p2)))
                           (p1^ (%avl (%key p1) (%data p1)
                                      (- (min bal2 0))
                                      (%right p2) (%right p1)))
                           (p2^ (%avl (%key p2) (%data p2) 0
                                      p^ p1^)))
                      (values p2^ #f)))
                   (else (internal-error))))
                (else (internal-error)))))))
         (else
          (values (%avl key data (%bal p) (%left p) (%right p))
                  #f))))
      (avl-check-usage
       (procedure? pred<?)
       "avl-insert expects a procedure as first argument")
      (if (avl-empty? tree)
          (%avl key data 0 #f #f)
          (let-values (((p fix-balance?) (search tree #f)))
            p)))

    (define (internal-error)
      (display "internal error\n" (current-error-port))
      (emergency-exit 123))

    (define (usage-error msg)
      (display "Procedure usage error:\n" (current-error-port))
      (display "  " (current-error-port))
      (display msg (current-error-port))
      (newline (current-error-port))
      (exit 1))

    )) ;; end library (avl-trees)


(define-library (associative-arrays)
  ;;
  ;; Persistent associative ‘arrays’ for R7RS Scheme.
  ;;
  ;; The structure is not actually an array, but is made of AVL trees
  ;; and association lists. Given a good hash function, it should
  ;; average logarithmic performance.
  ;;

  (export assoc-array-make-pair-generator
          assoc-array-make-key-generator
          assoc-array-make-data-generator)
  (export assoc-array assoc-array? assoc-array-set assoc-array-ref)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (scheme write))
  (import (suspendable-procedures))
  (import (avl-trees))

  (cond-expand
    (chicken (import (only (srfi 1) alist-delete)))
    ;; Insert whatever you need here for your Scheme.
    (else))

  (begin

    (define-record-type <assoc-array>
      (%assoc-array hashfunc pred=? default table)
      assoc-array?
      (hashfunc %hashfunc)
      (pred=? %pred=?)
      (default %default)
      (table %table))

    (define (assoc-array-make-generator array kind)
      (define tree-traverser (avl-make-generator (%table array)))
      (define get-desired-part
        (cond ((eq? kind 'key) (lambda (pair) (car pair)))
              ((eq? kind 'data) (lambda (pair) (cdr pair)))
              (else (lambda (pair) pair))))
      (make-generator-procedure
       (lambda ()
         (let traverse ()
           (let ((tree-entry (tree-traverser)))
             (when (success? tree-entry)
               (let scan-lst ((lst (cdr tree-entry)))
                 (when (pair? lst)
                   (suspend (get-desired-part (car lst)))
                   (scan-lst (cdr lst))))
               (traverse))))
         &fail)))

    (define (assoc-array-make-pair-generator array)
      (assoc-array-make-generator array 'pair))

    (define (assoc-array-make-key-generator array)
      (assoc-array-make-generator array 'key))

    (define (assoc-array-make-data-generator array)
      (assoc-array-make-generator array 'data))

    (define assoc-array
      (case-lambda
        ((hashfunc)
         (let ((pred=? equal?)
               (default #f))
           (assoc-array hashfunc pred=? default)))
        ((hashfunc pred=?)
         (let ((default #f))
           (assoc-array hashfunc pred=? default)))
        ((hashfunc pred=? default)
         (%assoc-array hashfunc pred=? default (avl)))))

    (define (assoc-array-set array key data)
      (let ((hashfunc (%hashfunc array))
            (pred=? (%pred=? array))
            (default (%default array))
            (table (%table array)))
        (let ((hash-value (hashfunc key)))
          (let*-values
              (((alst found?) (avl-search-values < table hash-value)))
            (cond
             (found?
              (let* ((alst (alist-delete key alst pred=?))
                     (alst `((,key . ,data) . ,alst))
                     (table (avl-insert < table hash-value alst)))
                (%assoc-array hashfunc pred=? default table)))
             (else
              (let* ((alst `((,key . ,data)))
                     (table (avl-insert < table hash-value alst)))
                (%assoc-array hashfunc pred=? default table))))))))

    (define (assoc-array-ref array key)
      (let* ((hashfunc (%hashfunc array))
             (hash-value (hashfunc key)))
        (let*-values
            (((alst found?)
              (avl-search-values < (%table array) hash-value)))
          (if found?
              (let ((pair (assoc key alst (%pred=? array))))
                (if pair
                    (cdr pair)
                    (%default array)))
              (%default array)))))

    )) ;; end library (associative-arrays)


(cond-expand
  (DEMONSTRATION
   (begin
     (import (scheme base))
     (import (scheme write))
     (import (suspendable-procedures))
     (import (associative-arrays))

     (define (hashfunc s)
       ;; Using Knuth’s random number generator to concoct a quick and
       ;; dirty and probably very bad hash function. It should be much
       ;; better to use something like SpookyHash, but this is a demo.
       (define a 6364136223846793005)
 	   (define c 1442695040888963407)
       (define M (expt 2 64))
       (let ((n (string-length s))
             (h 123))
         (do ((i 0 (+ i 1)))
             ((= i n))
           (let* ((x (char->integer (string-ref s i)))
                  (x (+ (* a (+ h x)) c)))
             (set! h (truncate-remainder x M))))
         h))

     (define a (assoc-array hashfunc))

     ;; Fill the associative array ‘a’ with (string . number)
     ;; associations.
     (do ((i 1 (+ i 1)))
         ((= i 11))
       (set! a (assoc-array-set a (number->string i) i)))

     ;; Go through the association pairs (in arbitrary order) with a
     ;; generator.
     (let ((gen (assoc-array-make-pair-generator a)))
       (do ((pair (gen) (gen)))
           ((failure? pair))
         (write pair) (display " "))
       (newline))

     ;; Go through the keys (in arbitrary order) with a generator.
     (let ((gen (assoc-array-make-key-generator a)))
       (do ((key (gen) (gen)))
           ((failure? key))
         (write key) (display " "))
       (newline))

     ;; Go through the values (in arbitrary order) with a generator.
     (let ((gen (assoc-array-make-data-generator a)))
       (do ((value (gen) (gen)))
           ((failure? value))
         (write value) (display " "))
       (newline))

     ))
  (else))
