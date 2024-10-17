(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(define-library (avl-trees)

  ;;
  ;; This library implements ‘persistent’ (that is, ‘immutable’) AVL
  ;; trees for R7RS Scheme.
  ;;
  ;; Included are generators of the key-data pairs in a tree. Because
  ;; the trees are persistent (‘immutable’), these generators are safe
  ;; from alterations of the tree.
  ;;
  ;; References:
  ;;
  ;;   * Niklaus Wirth, 1976. Algorithms + Data Structures =
  ;;     Programs. Prentice-Hall, Englewood Cliffs, New Jersey.
  ;;
  ;;   * Niklaus Wirth, 2004. Algorithms and Data Structures. Updated
  ;;     by Fyodor Tkachov, 2014.
  ;;
  ;; Note that the references do not discuss persistent
  ;; implementations. It seems worthwhile to compare the methods of
  ;; implementation.
  ;;

  (export avl)
  (export alist->avl)
  (export avl->alist)
  (export avl?)
  (export avl-empty?)
  (export avl-size)
  (export avl-insert)
  (export avl-delete)
  (export avl-delete-values)
  (export avl-has-key?)
  (export avl-search)
  (export avl-search-values)
  (export avl-make-generator)
  (export avl-pretty-print)
  (export avl-check-avl-condition)
  (export avl-check-usage)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (scheme process-context))
  (import (scheme write))

  (cond-expand
    (chicken
     (import (only (chicken base) define-record-printer))
     (import (only (chicken format) format))) ; For debugging.
    (else))

  (begin

    ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ;;
    ;; Tools for making generators. These use call/cc and so might be
    ;; inefficient in your Scheme. I am using CHICKEN, in which
    ;; call/cc is not so inefficient.
    ;;
    ;; Often I have made &fail a unique object rather than #f, but in
    ;; this case #f will suffice.
    ;;

    (define &fail #f)

    (define *suspend*
      (make-parameter (lambda (x) x)))

    (define (suspend v)
      ((*suspend*) v))

    (define (fail-forever)
      (let loop ()
        (suspend &fail)
        (loop)))

    (define (make-generator-procedure thunk)
      ;; Make a suspendable procedure that takes no arguments. The
      ;; result is a simple generator of values. (This can be
      ;; elaborated upon for generators to take values on resumption,
      ;; in the manner of Icon co-expressions.)
      (define (next-run return)
        (define (my-suspend v)
          (set! return (call/cc (lambda (resumption-point)
                                  (set! next-run resumption-point)
                                  (return v)))))
        (parameterize ((*suspend* my-suspend))
          (suspend (thunk))
          (fail-forever)))
      (lambda () (call/cc next-run)))

    ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    (define-syntax avl-check-usage
      (syntax-rules ()
        ((_ pred msg)
         (or pred (usage-error msg)))))

    ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    (define-record-type <avl>
      (%avl key data bal left right)
      avl?
      (key %key)
      (data %data)
      (bal %bal)
      (left %left)
      (right %right))

    (cond-expand
      (chicken (define-record-printer (<avl> rt out)
                 (display "#<avl " out)
                 (display (%key rt) out)
                 (display " " out)
                 (display (%data rt) out)
                 (display " " out)
                 (display (%bal rt) out)
                 (display " " out)
                 (display (%left rt) out)
                 (display " " out)
                 (display (%right rt) out)
                 (display ">" out)))
      (else))

    ;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    (define avl
      (case-lambda
        (() (%avl #f #f #f #f #f))
        ((pred<? . args) (alist->avl pred<? args))))

    (define (avl-empty? tree)
      (avl-check-usage
       (avl? tree)
       "avl-empty? expects an AVL tree as argument")
      (not (%bal tree)))

    (define (avl-size tree)
      (define (traverse p sz)
        (if (not p)
            sz
            (traverse (%left p) (traverse (%right p) (+ sz 1)))))
      (if (avl-empty? tree)
          0
          (traverse tree 0)))

    (define (avl-has-key? pred<? tree key)
      (define (search p)
        (and p
             (let ((k (%key p)))
               (cond ((pred<? key k) (search (%left p)))
                     ((pred<? k key) (search (%right p)))
                     (else #t)))))
      (avl-check-usage
       (procedure? pred<?)
       "avl-has-key? expects a procedure as first argument")
      (and (not (avl-empty? tree))
           (search tree)))

    (define (avl-search pred<? tree key)
      ;; Return the data matching a key, or #f if the key is not
      ;; found. (Note that the data matching the key might be #f.)
      (define (search p)
        (and p
             (let ((k (%key p)))
               (cond ((pred<? key k) (search (%left p)))
                     ((pred<? k key) (search (%right p)))
                     (else (%data p))))))
      (avl-check-usage
       (procedure? pred<?)
       "avl-search expects a procedure as first argument")
      (and (not (avl-empty? tree))
           (search tree)))

    (define (avl-search-values pred<? tree key)
      ;; Return two values: the data matching the key, or #f is the
      ;; key is not found; and a second value that is either #f or #t,
      ;; depending on whether the key is found.
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

    (define (alist->avl pred<? alst)
      ;; Go from association list to AVL tree.
      (avl-check-usage
       (procedure? pred<?)
       "alist->avl expects a procedure as first argument")
      (let loop ((tree (avl))
                 (lst alst))
        (if (null? lst)
            tree
            (let ((head (car lst)))
              (loop (avl-insert pred<? tree (car head) (cdr head))
                    (cdr lst))))))

    (define (avl->alist tree)
      ;; Go from AVL tree to association list. The output will be in
      ;; order.
      (define (traverse p lst)
        ;; Reverse in-order traversal of the tree, to produce an
        ;; in-order cons-list.
        (if (not p)
            lst
            (traverse (%left p) (cons (cons (%key p) (%data p))
                                      (traverse (%right p) lst)))))
      (if (avl-empty? tree)
          '()
          (traverse tree '())))

    (define (avl-insert pred<? tree key data)

      (define (search p fix-balance?)
        (cond
         ((not p)
          ;; The key was not found. Make a new node and set
          ;; fix-balance?
          (values (%avl key data 0 #f #f) #t))

         ((pred<? key (%key p))
          ;; Continue searching.
          (let-values (((p1 fix-balance?)
                        (search (%left p) fix-balance?)))
            (cond
             ((not fix-balance?)
              (let ((p^ (%avl (%key p) (%data p) (%bal p)
                              p1 (%right p))))
                (values p^ #f)))
             (else
              ;; A new node has been inserted on the left side.
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
                 ;; Rebalance.
                 (case (%bal p1)
                   ((-1)
                    ;; A single LL rotation.
                    (let* ((p^ (%avl (%key p) (%data p) 0
                                     (%right p1) (%right p)))
                           (p1^ (%avl (%key p1) (%data p1) 0
                                      (%left p1) p^)))
                      (values p1^ #f)))
                   ((0 1)
                    ;; A double LR rotation.
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
          ;; Continue searching.
          (let-values (((p1 fix-balance?)
                        (search (%right p) fix-balance?)))
            (cond
             ((not fix-balance?)
              (let ((p^ (%avl (%key p) (%data p) (%bal p)
                              (%left p) p1)))
                (values p^ #f)))
             (else
              ;; A new node has been inserted on the right side.
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
                 ;; Rebalance.
                 (case (%bal p1)
                   ((1)
                    ;; A single RR rotation.
                    (let* ((p^ (%avl (%key p) (%data p) 0
                                     (%left p) (%left p1)))
                           (p1^ (%avl (%key p1) (%data p1) 0
                                      p^ (%right p1))))
                      (values p1^ #f)))
                   ((-1 0)
                    ;; A double RL rotation.
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
          ;; The key was found; p is an existing node.
          (values (%avl key data (%bal p) (%left p) (%right p))
                  #f))))

      (avl-check-usage
       (procedure? pred<?)
       "avl-insert expects a procedure as first argument")
      (if (avl-empty? tree)
          (%avl key data 0 #f #f)
          (let-values (((p fix-balance?) (search tree #f)))
            p)))

    (define (avl-delete pred<? tree key)
      ;; If one is not interested in whether the key was in the tree,
      ;; then throw away that information.
      (let-values (((tree had-key?)
                    (avl-delete-values pred<? tree key)))
        tree))

    (define (balance-for-shrunken-left p)
      ;; Returns two values: a new p and a new fix-balance?
      (case (%bal p)
        ((-1) (values (%avl (%key p) (%data p) 0
                            (%left p) (%right p))
                      #t))
        ((0) (values (%avl (%key p) (%data p) 1
                           (%left p) (%right p))
                     #f))
        ((1)
         ;; Rebalance.
         (let* ((p1 (%right p))
                (bal1 (%bal p1)))
           (case bal1
             ((0)
              ;; A single RR rotation.
              (let* ((p^ (%avl (%key p) (%data p) 1
                               (%left p) (%left p1)))
                     (p1^ (%avl (%key p1) (%data p1) -1
                                p^ (%right p1))))
                (values p1^ #f)))
             ((1)
              ;; A single RR rotation.
              (let* ((p^ (%avl (%key p) (%data p) 0
                               (%left p) (%left p1)))
                     (p1^ (%avl (%key p1) (%data p1) 0
                                p^ (%right p1))))
                (values p1^ #t)))
             ((-1)
              ;; A double RL rotation.
              (let* ((p2 (%left p1))
                     (bal2 (%bal p2))
                     (p^ (%avl (%key p) (%data p) (- (max bal2 0))
                               (%left p) (%left p2)))
                     (p1^ (%avl (%key p1) (%data p1) (- (min bal2 0))
                                (%right p2) (%right p1)))
                     (p2^ (%avl (%key p2) (%data p2) 0 p^ p1^)))
                (values p2^ #t)))
             (else (internal-error)))))
        (else (internal-error))))

    (define (balance-for-shrunken-right p)
      ;; Returns two values: a new p and a new fix-balance?
      (case (%bal p)
        ((1) (values (%avl (%key p) (%data p) 0
                           (%left p) (%right p))
                     #t))
        ((0) (values (%avl (%key p) (%data p) -1
                           (%left p) (%right p))
                     #f))
        ((-1)
         ;; Rebalance.
         (let* ((p1 (%left p))
                (bal1 (%bal p1)))
           (case bal1
             ((0)
              ;; A single LL rotation.
              (let* ((p^ (%avl (%key p) (%data p) -1
                               (%right p1) (%right p)))
                     (p1^ (%avl (%key p1) (%data p1) 1
                                (%left p1) p^)))
                (values p1^ #f)))
             ((-1)
              ;; A single LL rotation.
              (let* ((p^ (%avl (%key p) (%data p) 0
                               (%right p1) (%right p)))
                     (p1^ (%avl (%key p1) (%data p1) 0
                                (%left p1) p^)))
                (values p1^ #t)))
             ((1)
              ;; A double LR rotation.
              (let* ((p2 (%right p1))
                     (bal2 (%bal p2))
                     (p^ (%avl (%key p) (%data p) (- (min bal2 0))
                               (%right p2) (%right p)))
                     (p1^ (%avl (%key p1) (%data p1) (- (max bal2 0))
                                (%left p1) (%left p2)))
                     (p2^ (%avl (%key p2) (%data p2) 0 p1^ p^)))
                (values p2^ #t)))
             (else (internal-error)))))
        (else (internal-error))))

    (define (avl-delete-values pred<? tree key)

      (define-syntax balance-L
        (syntax-rules ()
          ((_ p fix-balance?)
           (if fix-balance?
               (balance-for-shrunken-left p)
               (values p #f)))))

      (define-syntax balance-R
        (syntax-rules ()
          ((_ p fix-balance?)
           (if fix-balance?
               (balance-for-shrunken-right p)
               (values p #f)))))

      (define (del r fix-balance?)
        ;; Returns a new r, a new fix-balance?, and key and data to be
        ;; ‘moved up the tree’.
        (if (%right r)
            (let*-values
                (((q fix-balance? key^ data^)
                  (del (%right r) fix-balance?))
                 ((r fix-balance?)
                  (balance-R (%avl (%key r) (%data r) (%bal r)
                                   (%left r) q)
                             fix-balance?)))
              (values r fix-balance? key^ data^))
            (values (%left r) #t (%key r) (%data r))))

      (define (search p fix-balance?)
        ;; Return three values: a new p, a new fix-balance, and
        ;; whether the key was found.
        (cond
         ((not p) (values #f #f #f))
         ((pred<? key (%key p))
          ;; Recursive search down the left branch.
          (let*-values
              (((q fix-balance? found?)
                (search (%left p) fix-balance?))
               ((p fix-balance?)
                (balance-L (%avl (%key p) (%data p) (%bal p)
                                 q (%right p))
                           fix-balance?)))
            (values p fix-balance? found?)))
         ((pred<? (%key p) key)
          ;; Recursive search down the right branch.
          (let*-values
              (((q fix-balance? found?)
                (search (%right p) fix-balance?))
               ((p fix-balance?)
                (balance-R (%avl (%key p) (%data p) (%bal p)
                                 (%left p) q)
                           fix-balance?)))
            (values p fix-balance? found?)))
         ((not (%right p))
          ;; Delete p, replace it with its left branch, then
          ;; rebalance.
          (values (%left p) #t #t))
         ((not (%left p))
          ;; Delete p, replace it with its right branch, then
          ;; rebalance.
          (values (%right p) #t #t))
         (else
          ;; Delete p, but it has both left and right branches,
          ;; and therefore may have complicated branch structure.
          (let*-values
              (((q fix-balance? key^ data^)
                (del (%left p) fix-balance?))
               ((p fix-balance?)
                (balance-L (%avl key^ data^ (%bal p) q (%right p))
                           fix-balance?)))
            (values p fix-balance? #t)))))

      (avl-check-usage
       (procedure? pred<?)
       "avl-delete-values expects a procedure as first argument")
      (if (avl-empty? tree)
          (values tree #f)
          (let-values (((tree fix-balance? found?)
                        (search tree #f)))
            (if found?
                (values (or tree (avl)) #t)
                (values tree #f)))))

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

    (define avl-pretty-print
      (case-lambda
        ((tree)
         (avl-pretty-print tree (current-output-port)))
        ((tree port)
         (avl-pretty-print tree port
                           (lambda (port key data)
                             (display "(" port)
                             (write key port)
                             (display ", " port)
                             (write data port)
                             (display ")" port))))
        ((tree port key-data-printer)
         ;; In-order traversal, so the printing is done in
         ;; order. Reflect the display diagonally to get the more
         ;; usual orientation of left-to-right, top-to-bottom.
         (define (pad depth)
           (unless (zero? depth)
             (display "  " port)
             (pad (- depth 1))))
         (define (traverse p depth)
           (when p
             (traverse (%left p) (+ depth 1))
             (pad depth)
             (key-data-printer port (%key p) (%data p))
             (display "\t\tdepth = " port)
             (display depth port)
             (display " bal = " port)
             (display (%bal p) port)
             (display "\n" port)
             (traverse (%right p) (+ depth 1))))
         (unless (avl-empty? tree)
           (traverse (%left tree) 1)
           (key-data-printer port (%key tree) (%data tree))
           (display "\t\tdepth = 0  bal = " port)
           (display (%bal tree) port)
           (display "\n" port)
           (traverse (%right tree) 1)))))

    (define (avl-check-avl-condition tree)
      ;; Check that the AVL condition is satisfied.
      (define (check-heights height-L height-R)
        (when (<= 2 (abs (- height-L height-R)))
          (display "*** AVL condition violated ***"
                   (current-error-port))
          (internal-error)))
      (define (get-heights p)
        (if (not p)
            (values 0 0)
            (let-values (((height-LL height-LR)
                          (get-heights (%left p)))
                         ((height-RL height-RR)
                          (get-heights (%right p))))
              (check-heights height-LL height-LR)
              (check-heights height-RL height-RR)
              (values (+ height-LL height-LR)
                      (+ height-RL height-RR)))))
      (unless (avl-empty? tree)
        (let-values (((height-L height-R) (get-heights tree)))
          (check-heights height-L height-R))))

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


(cond-expand
  (DEMONSTRATION
   (begin
     (import (avl-trees))
     (import (scheme base))
     (import (scheme time))
     (import (scheme process-context))
     (import (scheme write))

     (cond-expand
       (chicken
        (import (only (chicken format) format))) ; For debugging.
       (else))

     (define 2**64 (expt 2 64))

     (define seed (truncate-remainder (exact (current-second)) 2**64))
     (define random
       ;; A really slow (but presumably highly portable)
       ;; implementation of Donald Knuth’s linear congruential random
       ;; number generator, returning a rational number in [0,1). See
       ;; https://en.wikipedia.org/w/index.php?title=Linear_congruential_generator&oldid=1076681286
       (let ((a 6364136223846793005)
             (c 1442695040888963407))
         (lambda ()
           (let ((result (/ seed 2**64)))
             (set! seed (truncate-remainder (+ (* a seed) c) 2**64))
             result))))
     (do ((i 0 (+ i 1)))
         ((= i 10))
       (random))

     (define (fisher-yates-shuffle keys)
       (let ((n (vector-length keys)))
         (do ((i 1 (+ i 1)))
             ((= i n))
           (let* ((randnum (random))
                  (j (+ i (floor (* randnum (- n i)))))
                  (xi (vector-ref keys i))
                  (xj (vector-ref keys j)))
             (vector-set! keys i xj)
             (vector-set! keys j xi)))))

     (define (display-key-data key data)
       (display "(")
       (write key)
       (display ", ")
       (write data)
       (display ")"))

     (define (display-tree-contents tree)
       (do ((p (avl->alist tree) (cdr p)))
           ((null? p))
         (display-key-data (caar p) (cdar p))
         (newline)))

     (define (error-stop)
       (display "*** ERROR STOP ***\n" (current-error-port))
       (emergency-exit 1))

     (define n 20)
     (define keys (make-vector (+ n 1)))
     (do ((i 0 (+ i 1)))
         ((= i n))
       ;; To keep things more like Fortran, do not use index zero.
       (vector-set! keys (+ i 1) (+ i 1)))

     (fisher-yates-shuffle keys)

     ;; Insert key-data pairs in the shuffled order.
     (define tree (avl))
     (avl-check-avl-condition tree)
     (do ((i 1 (+ i 1)))
         ((= i (+ n 1)))
       (let ((ix (vector-ref keys i)))
         (set! tree (avl-insert < tree ix (inexact ix)))
         (avl-check-avl-condition tree)
         (do ((j 1 (+ j 1)))
             ((= j (+ n 1)))
           (let*-values (((k) (vector-ref keys j))
                         ((has-key?) (avl-has-key? < tree k))
                         ((data) (avl-search < tree k))
                         ((data^ has-key?^)
                          (avl-search-values < tree k)))
             (unless (exact? k) (error-stop))
             (if (<= j i)
                 (unless (and has-key? data data^ has-key?^
                              (inexact? data) (= data k)
                              (inexact? data^) (= data^ k))
                   (error-stop))
                 (when (or has-key? data data^ has-key?^)
                   (error-stop)))))))

     (display "----------------------------------------------------------------------\n")
     (display "keys = ")
     (write (cdr (vector->list keys)))
     (newline)
     (display "----------------------------------------------------------------------\n")
     (avl-pretty-print tree)
     (display "----------------------------------------------------------------------\n")
     (display "tree size = ")
     (display (avl-size tree))
     (newline)
     (display-tree-contents tree)
     (display "----------------------------------------------------------------------\n")

     ;;
     ;; Reshuffle the keys, and change the data from inexact numbers
     ;; to strings.
     ;;

     (fisher-yates-shuffle keys)

     (do ((i 1 (+ i 1)))
         ((= i (+ n 1)))
       (let ((ix (vector-ref keys i)))
         (set! tree (avl-insert < tree ix (number->string ix)))
         (avl-check-avl-condition tree)))

     (avl-pretty-print tree)
     (display "----------------------------------------------------------------------\n")
     (display "tree size = ")
     (display (avl-size tree))
     (newline)
     (display-tree-contents tree)
     (display "----------------------------------------------------------------------\n")

     ;;
     ;; Reshuffle the keys, and delete the contents of the tree, but
     ;; also keep the original tree by saving it in a variable. Check
     ;; persistence of the tree.
     ;;

     (fisher-yates-shuffle keys)

     (define saved-tree tree)

     (do ((i 1 (+ i 1)))
         ((= i (+ n 1)))
       (let ((ix (vector-ref keys i)))
         (set! tree (avl-delete < tree ix))
         (avl-check-avl-condition tree)
         (unless (= (avl-size tree) (- n i)) (error-stop))
         ;; Try deleting a second time.
         (set! tree (avl-delete < tree ix))
         (avl-check-avl-condition tree)
         (unless (= (avl-size tree) (- n i)) (error-stop))
         (do ((j 1 (+ j 1)))
             ((= j (+ n 1)))
           (let ((jx (vector-ref keys j)))
             (unless (eq? (avl-has-key? < tree jx) (< i j))
               (error-stop))
             (let ((data (avl-search < tree jx)))
               (unless (eq? (not (not data)) (< i j))
                 (error-stop))
               (unless (or (not data)
                           (= (string->number data) jx))
                 (error-stop)))
             (let-values (((data found?)
                           (avl-search-values < tree jx)))
               (unless (eq? found? (< i j)) (error-stop))
               (unless (or (and (not data) (<= j i))
                           (and data (= (string->number data) jx)))
                 (error-stop)))))))
     (do ((i 1 (+ i 1)))
         ((= i (+ n 1)))
       ;; Is save-tree the persistent value of the tree we just
       ;; deleted?
       (let ((ix (vector-ref keys i)))
         (unless (equal? (avl-search < saved-tree ix)
                         (number->string ix))
           (error-stop))))

     (display "forwards generator:\n")
     (let ((gen (avl-make-generator saved-tree)))
       (do ((pair (gen) (gen)))
           ((not pair))
         (display-key-data (car pair) (cdr pair))
         (newline)))

     (display "----------------------------------------------------------------------\n")

     (display "backwards generator:\n")
     (let ((gen (avl-make-generator saved-tree -1)))
       (do ((pair (gen) (gen)))
           ((not pair))
         (display-key-data (car pair) (cdr pair))
         (newline)))

     (display "----------------------------------------------------------------------\n")

     ))
  (else))
