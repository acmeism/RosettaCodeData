(define-library (rosetta-code k-way-merge)

  (export k-way-merge)

  (import (scheme base))
  (import (scheme case-lambda))
  (import (only (srfi 1) car+cdr))
  (import (only (srfi 1) reverse!))
  (import (only (srfi 132) list-merge))
  (import (only (srfi 151) bitwise-xor))

  (begin

    ;;
    ;; The algorithm employed here is "tournament tree" as in the
    ;; following article, which is based on Knuth, volume 3.
    ;;
    ;;   https://en.wikipedia.org/w/index.php?title=K-way_merge_algorithm&oldid=1047851465#Tournament_Tree
    ;;
    ;; However, I store a winners tree instead of the recommended
    ;; losers tree. If the tree were stored as linked nodes, it would
    ;; probably be more efficient to store a losers tree. However, I
    ;; am storing the tree as a Scheme vector, and one can find an
    ;; opponent quickly by simply toggling the least significant bit
    ;; of a competitor's array index.
    ;;

    (define // truncate-quotient)

    (define-record-type <infinity>
      (make-infinity)
      infinity?)

    (define infinity (make-infinity))

    (define (next-power-of-two n)
      ;; This need not be a fast implementation. It can assume n >= 3,
      ;; because one can use an ordinary 2-way merge for n = 2.
      (let loop ((pow2 4))
        (if (<= n pow2)
            pow2
            (loop (+ pow2 pow2)))))

    (define (play-game <? x y)
      (cond ((infinity? x) #f)
            ((infinity? y) #t)
            (else (not (<? y x)))))

    (define (build-tree <? heads)
      ;; We do not use vector indices of zero. Thus our indexing is
      ;; 1-based.
      (let* ((total-external-nodes (next-power-of-two
                                    (vector-length heads)))
             (total-nodes (- (* 2 total-external-nodes) 1))
             (winners (make-vector (+ total-nodes 1))))
        (do ((i 0 (+ i 1)))
            ((= i total-external-nodes))
          (let ((j (+ total-external-nodes i)))
            (if (< i (vector-length heads))
                (let ((entry (cons (vector-ref heads i) i)))
                  (vector-set! winners j entry))
                (let ((entry (cons infinity i)))
                  (vector-set! winners j entry)))))
        (let loop ((istart total-external-nodes))
          (do ((i istart (+ i 2)))
              ((= i (+ istart istart)))
            (let* ((i1 i)
                   (i2 (bitwise-xor i 1))
                   (elem1 (car (vector-ref winners i1)))
                   (elem2 (car (vector-ref winners i2)))
                   (wins1? (play-game <? elem1 elem2))
                   (iwinner (if wins1? i1 i2))
                   (winner (vector-ref winners iwinner))
                   (iparent (// i 2)))
              (vector-set! winners iparent winner)))
          (if (= istart 2)
              winners
              (loop (// istart 2))))))

    (define (replay-games <? winners i)
      (let loop ((i i))
        (unless (= i 1)
          (let* ((i1 i)
                 (i2 (bitwise-xor i 1))
                 (elem1 (car (vector-ref winners i1)))
                 (elem2 (car (vector-ref winners i2)))
                 (wins1? (play-game <? elem1 elem2))
                 (iwinner (if wins1? i1 i2))
                 (winner (vector-ref winners iwinner))
                 (iparent (// i 2)))
            (vector-set! winners iparent winner)
            (loop iparent)))))

    (define (get-next lst)
      (if (null? lst)
          (values infinity lst)      ; End of list. Return a sentinel.
          (car+cdr lst)))

    (define (merge-lists <? lists)
      (let* ((heads (list->vector (map car lists)))
             (tails (list->vector (map cdr lists))))
        (let ((winners (build-tree <? heads)))
          (let loop ((outputs '()))
            (let-values (((winner-value winner-index)
                          (car+cdr (vector-ref winners 1))))
              (if (infinity? winner-value)
                  (reverse! outputs)
                  (let-values
                      (((hd tl)
                        (get-next (vector-ref tails winner-index))))
                    (vector-set! tails winner-index tl)
                    (let ((entry (cons hd winner-index))
                          (i (+ (// (vector-length winners) 2)
                                winner-index)))
                      (vector-set! winners i entry)
                      (replay-games <? winners i)
                      (loop (cons winner-value outputs))))))))))

    (define k-way-merge
      (case-lambda
        ((<? lst1) lst1)
        ((<? lst1 lst2) (list-merge <? lst1 lst2))
        ((<? . lists) (merge-lists <? lists))))

    )) ;; library (rosetta-code k-way-merge)

(define-library (rosetta-code patience-sort)

  (export patience-sort)

  (import (scheme base))
  (import (rosetta-code k-way-merge))

  (begin

    (define (find-pile <? x num-piles piles)
      ;;
      ;; Do a Bottenbruch search for the leftmost pile whose top is
      ;; greater than or equal to x. The search starts at 0 and ends
      ;; at (- num-piles 1). Return an index such that:
      ;;
      ;;   * if x is greater than the top element at the far right,
      ;;     then the index returned will be num-piles.
      ;;
      ;;   * otherwise, x is greater than every top element to the
      ;;     left of index, and less than or equal to the top elements
      ;;     at index and to the right of index.
      ;;
      ;; References:
      ;;
      ;;   * H. Bottenbruch, "Structure and use of ALGOL 60", Journal
      ;;     of the ACM, Volume 9, Issue 2, April 1962, pp.161-221.
      ;;     https://doi.org/10.1145/321119.321120
      ;;
      ;;     The general algorithm is described on pages 214 and 215.
      ;;
      ;;   * https://en.wikipedia.org/w/index.php?title=Binary_search_algorithm&oldid=1062988272#Alternative_procedure
      ;;
      (let loop ((j 0)
                 (k (- num-piles 1)))
        (if (= j k)
            (if (or (not (= j (- num-piles 1)))
                    (not (<? (car (vector-ref piles j)) x)))
                j                      ; x fits onto one of the piles.
                (+ j 1))               ; x needs a new pile.
            (let ((i (floor-quotient (+ j k) 2)))
              (if (<? (car (vector-ref piles i)) x)
                  ;; x is greater than the element at i.
                  (loop (+ i 1) k)
                  (loop j i))))))

    (define (resize-table table-size num-piles piles)
      ;; If necessary, allocate a new table of larger size.
      (if (not (= num-piles table-size))
          (values table-size piles)
          (let* ((new-size (* table-size 2))
                 (new-piles (make-vector new-size)))
            (vector-copy! new-piles 0 piles)
            (values new-size new-piles))))

    (define initial-table-size 64)

    (define (deal <? lst)
      (let loop ((lst lst)
                 (table-size initial-table-size)
                 (num-piles 0)
                 (piles (make-vector initial-table-size)))
        (cond ((null? lst) (values num-piles piles))
              ((zero? num-piles)
               (vector-set! piles 0 (list (car lst)))
               (loop (cdr lst) table-size 1 piles))
              (else
               (let* ((x (car lst))
                      (i (find-pile <? x num-piles piles)))
                 (if (= i num-piles)
                     (let-values (((table-size piles)
                                   (resize-table table-size num-piles
                                                 piles)))
                       ;; Start a new pile at the far right.
                       (vector-set! piles num-piles (list x))
                       (loop (cdr lst) table-size (+ num-piles 1)
                             piles))
                     (begin
                       (vector-set! piles i
                                    (cons x (vector-ref piles i)))
                       (loop (cdr lst) table-size num-piles
                             piles))))))))

    (define (patience-sort <? lst)
      (let-values (((num-piles piles) (deal <? lst)))
        (apply k-way-merge
               (cons <? (vector->list piles 0 num-piles)))))

    )) ;; library (rosetta-code patience-sort)

;;--------------------------------------------------------------------
;;
;; A little demonstration.
;;

(import (scheme base))
(import (scheme write))
(import (rosetta-code patience-sort))

(define example-numbers '(22 15 98 82 22 4 58 70 80 38 49 48 46 54 93
                             8 54 2 72 84 86 76 53 37 90))
(display "unsorted   ")
(write example-numbers)
(newline)
(display "sorted     ")
(write (patience-sort < example-numbers))
(newline)

;;--------------------------------------------------------------------
