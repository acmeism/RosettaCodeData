(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(define-library (avl-trees)

  ;;
  ;; This library implements ‘persistent’ (that is, ‘immutable’) AVL
  ;; trees for R7RS Scheme.
  ;;
  ;; References:
  ;;
  ;;   * Niklaus Wirth, 1976. Algorithms + Data Structures =
  ;;     Programs. Prentice-Hall, Englewood Cliffs, New Jersey.
  ;;
  ;;   * Niklaus Wirth, 2004. Algorithms and Data Structures. Updated
  ;;     by Fyodor Tkachov, 2014.
  ;;
  ;; THIS IS A TRIMMED-DOWN VERSION OF MY SOLUTION TO THE AVL TREES
  ;; TASK: https://rosettacode.org/wiki/AVL_tree#Scheme
  ;;

  (export avl)
  (export avl?)
  (export avl-empty?)
  (export avl-insert)
  (export avl-search-values)
  (export avl-check-usage)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (scheme process-context))
  (import (scheme write))

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

    (define (avl)
      (%avl #f #f #f #f #f))

    (define (avl-empty? tree)
      (avl-check-usage
       (avl? tree)
       "avl-empty? expects an AVL tree as argument")
      (not (%bal tree)))

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
  ;; Persistent associative arrays for R7RS Scheme.
  ;;
  ;; The story:
  ;;
  ;; An implementation of associative arrays, where keys are compared
  ;; with an ‘equal to’ predicate, typically has three parts:
  ;;
  ;;    * a hash function, which converts a key to a hash value; and
  ;;      the hash value either has a ‘less than’ predicate or can be
  ;;      put in a radix tree;
  ;;
  ;;    * a table keyed by the hash values;
  ;;
  ;;    * a way to resolve hash value collisions.
  ;;
  ;; At one extreme is the association list, which can be viewed as
  ;; having a hash function that *always* collides. At a nearly
  ;; opposite extreme are ideal hash trees, which never have
  ;; collisions, but which, towards that end, require hash values to
  ;; ‘grow’ on the fly.
  ;;
  ;; Perhaps the simplest form of associative array having all three
  ;; parts is ‘separate chaining’: the hash function generates an
  ;; integer modulo some table size; the table itself is an array of
  ;; that size; and collisions are resolved by falling back to an
  ;; association list.
  ;;
  ;; Below I use my solution to the AVL Tree task
  ;; (https://rosettacode.org/wiki/AVL_tree#Scheme) to implement
  ;; *persistent* (that is, ‘immutable’) associative arrays. The hash
  ;; function is whatever you want, as long as it produces (what
  ;; Scheme regards as) a real number. Hash value collisions are
  ;; resolved by falling back to association lists.
  ;;

  (export assoc-array)
  (export assoc-array?)
  (export assoc-array-set)
  (export assoc-array-ref)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (scheme write))
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

    (define assoc-array
      ;; Create an associative array.
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
      ;; Produce a new associative array that is the same as the input
      ;; array except for the given key-data association. The input
      ;; array is left unchanged (which is why the procedure is called
      ;; ‘assoc-array-set’ rather than ‘assoc-array-set!’).
      (let ((hashfunc (%hashfunc array))
            (pred=? (%pred=? array))
            (default (%default array))
            (table (%table array)))
        (let ((hash-value (hashfunc key)))
          ;; The following could be made more efficient by combining
          ;; the ‘search’ and ‘insert’ operations for the AVL tree.
          (let*-values
              (((alst found?) (avl-search-values < table hash-value)))
            (cond
             (found?
              ;; Add a new entry to the association list. Removal of
              ;; any old associations with the key is not strictly
              ;; necessary, but without it the associative array will
              ;; grow every time you replace an
              ;; association. (Alternatively, you could occasionally
              ;; clean the associative array of shadowed key
              ;; associations.)
              (let* ((alst (alist-delete key alst pred=?))
                     (alst `((,key . ,data) . ,alst))
                     (table (avl-insert < table hash-value alst)))
                (%assoc-array hashfunc pred=? default table)))
             (else
              ;; Start a new association list.
              (let* ((alst `((,key . ,data)))
                     (table (avl-insert < table hash-value alst)))
                (%assoc-array hashfunc pred=? default table))))))))

    (define (assoc-array-ref array key)
      ;; Return the data associated with the key. If the key is not in
      ;; the table, return the associative array’s default data.
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
     (import (srfi 151))
     (import (associative-arrays))

     ;; I like SpookyHash, but for this demonstration I shall use the
     ;; simpler ‘ElfHash’ and define it only for strings. See
     ;; https://en.wikipedia.org/w/index.php?title=PJW_hash_function&oldid=997863283
     (define (hashfunc s)
       (let ((n (string-length s))
             (h 0))
         (do ((i 0 (+ i 1)))
             ((= i n))
           (let* ((ch
                   ;; If the character is outside the 8-bit range,
                   ;; probably I should break it into four bytes, each
                   ;; incorporated separately into the hash. For this
                   ;; demonstration, I shall simply discard the higher
                   ;; bits.
                   (bitwise-and (char->integer (string-ref s i))
                                #xFF))
                  (h^ (+ (arithmetic-shift h 4) ch))
                  (high^ (bitwise-and h^ #xF0000000)))
             (unless (zero? high^)
               (set! h^
                 (bitwise-xor h^ (arithmetic-shift high^ -24))))
             (set! h (bitwise-and h^ (bitwise-not high^)))))
         h))

     (let* ((a1 (assoc-array hashfunc))
            (a2 (assoc-array-set a1 "A" #\A))
            (a3 (assoc-array-set a2 "B" #x42)) ; ASCII ‘B’.
            (a4 (assoc-array-set a3 "C" "C")))
       (write (assoc-array-ref a1 "A")) (newline)
       (write (assoc-array-ref a1 "B")) (newline)
       (write (assoc-array-ref a1 "C")) (newline)
       (write (assoc-array-ref a2 "A")) (newline)
       (write (assoc-array-ref a2 "B")) (newline)
       (write (assoc-array-ref a2 "C")) (newline)
       (write (assoc-array-ref a3 "A")) (newline)
       (write (assoc-array-ref a3 "B")) (newline)
       (write (assoc-array-ref a3 "C")) (newline)
       (write (assoc-array-ref a4 "A")) (newline)
       (write (assoc-array-ref a4 "B")) (newline)
       (write (assoc-array-ref a4 "C")) (newline))

     ))
  (else))
