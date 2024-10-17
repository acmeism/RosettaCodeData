;;;
;;; Solutions to the Peaceful Chess Queen Armies puzzle, in R7RS
;;; Scheme. This implementation returns only one of each equivalent
;;; solution. See https://oeis.org/A260680
;;;
;;; I weed out equivalent solutions by comparing them tediously
;;; against solutions already found.
;;;
;;; (At least when compiled with CHICKEN 5.3.0, this program gets kind
;;; of slow for m=5, n=6, once you get past having found the 35
;;; non-equivalent solutions. There are still other, equivalent
;;; solutions to eliminate.)
;;;
;;; https://rosettacode.org/wiki/Peaceful_chess_queen_armies
;;;

(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme process-context))

(define-record-type <&fail>
  (make-the-one-unique-&fail-that-you-must-not-make-twice)
  do-not-use-this:&fail?)

(define &fail
  (make-the-one-unique-&fail-that-you-must-not-make-twice))

(define (failure? f)
  (eq? f &fail))

(define (success? f)
  (not (failure? f)))

(define *suspend*
  (make-parameter (lambda (x) x)))

(define (suspend v)
  ((*suspend*) v))

(define (fail-forever)
  (let loop ()
    (suspend &fail)
    (loop)))

(define (make-generator-procedure thunk)
  ;;
  ;; Make a suspendable procedure that takes no arguments. It is a
  ;; simple generator of values. (One can elaborate on this to have
  ;; the procedure accept an argument upon resumption, like an Icon
  ;; co-expression.)
  ;;
  (define (next-run return)
    (define (my-suspend v)
      (set! return
        (call/cc
         (lambda (resumption-point)
           (set! next-run resumption-point)
           (return v)))))
    (parameterize ((*suspend* my-suspend))
      (suspend (thunk))
      (fail-forever)))
  (lambda ()
    (call/cc next-run)))

(define (isqrt m)
  ;; Integer Newton’s method. See
  ;; https://en.wikipedia.org/w/index.php?title=Integer_square_root&oldid=1074473475#Using_only_integer_division
  (let ((k (truncate-quotient m 2)))
    (if (zero? k)
        m
        (let loop ((k k)
                   (k^ (truncate-quotient
                        (+ k (truncate-quotient m k)) 2)))
          (if (< k^ k)
              (loop k^ (truncate-quotient
                        (+ k^ (truncate-quotient m k^)) 2))
              k)))))

(define (ij->index n i j)
  (let ((i1 (- i 1))
        (j1 (- j 1)))
    (+ i1 (* n j1))))

(define (index->ij n index)
  (let-values (((q r) (floor/ index n)))
    (values (+ r 1) (+ q 1))))

(define (advance-ij n i j)
  (index->ij n (+ (ij->index n i j) 1)))

(define (index-rotate90 n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n (- n j -1) i)))

(define (index-rotate180 n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n (- n i -1) (- n j -1))))

(define (index-rotate270 n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n j (- n i -1))))

(define (index-reflecti n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n (- n i -1) j)))

(define (index-reflectj n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n i (- n j -1))))

(define (index-reflect-diag-down n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n j i)))

(define (index-reflect-diag-up n index)
  (let-values (((i j) (index->ij n index)))
    (ij->index n (- n j -1) (- n i -1))))

(define BLACK 'B)
(define WHITE 'W)

(define (reverse-color c)
  (cond ((eq? c WHITE) BLACK)
        ((eq? c BLACK) WHITE)
        (else c)))

(define (pick-color-adjuster c)
  (if (eq? c WHITE)
      reverse-color
      (lambda (x) x)))

(define-record-type <queen>
  (make-queen color rank file)
  queen?
  (color queen-color)
  (rank queen-rank)
  (file queen-file))

(define (queens->board queens)
  (let ((board (make-vector (* n n) #f)))
    (do ((q queens (cdr q)))
        ((null? q))
      (let* ((color (queen-color (car q)))
             (i (queen-rank (car q)))
             (j (queen-file (car q))))
        (vector-set! board (ij->index n i j) color)))
    board))

(define-syntax board-partial-equiv?
  (syntax-rules ()
    ((_ board1 board2 n*n n reindex recolor)
     (let loop ((i 0))
       (or (= i n*n)
           (let ((color1 (vector-ref board1 i))
                 (color2 (recolor (vector-ref board2 (reindex n i)))))
             (and (eq? color1 color2)
                  (loop (+ i 1)))))))))

(define (board-equiv? board1 board2)
  (define (identity x) x)
  (define (2nd-argument n i) i)
  (let ((n*n (vector-length board1)))
    (or (board-partial-equiv? board1 board2 n*n #f
                              2nd-argument identity)
        (board-partial-equiv? board1 board2 n*n #f
                              2nd-argument reverse-color)
        (let ((n (isqrt n*n)))
          (or (board-partial-equiv? board1 board2 n*n n
                                    index-rotate90
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-rotate90
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-rotate180
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-rotate180
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-rotate270
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-rotate270
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflecti
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflecti
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflectj
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflectj
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflect-diag-down
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflect-diag-down
                                    reverse-color)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflect-diag-up
                                    identity)
              (board-partial-equiv? board1 board2 n*n n
                                    index-reflect-diag-up
                                    reverse-color) )))))

(define (queens->string n queens)

  (define board (queens->board queens))

  (define rule
    (let ((str "+"))
      (do ((j 1 (+ j 1)))
          ((= j (+ n 1)))
        (set! str (string-append str "----+")))
      str))

  (define str "")

  (when (< 0 n)
    (set! str rule)
    (do ((i n (- i 1)))
        ((= i 0))
      (set! str (string-append str "\n"))
      (do ((j 1 (+ j 1)))
          ((= j (+ n 1)))
        (let* ((color (vector-ref board (ij->index n i j)))
               (representation
                (cond ((eq? color #f) "    ")
                      ((eq? color BLACK) "  B ")
                      ((eq? color WHITE) "  W ")
                      (else " ?? "))))
          (set! str (string-append str "|" representation))))
      (set! str (string-append str "|\n" rule))))
  str)

(define (queen-fits-in? queen other-queens)
  (or (null? other-queens)
      (let ((other (car other-queens)))
        (let ((colorq (queen-color queen))
              (rankq (queen-rank queen))
              (fileq (queen-file queen))
              (coloro (queen-color other))
              (ranko (queen-rank other))
              (fileo (queen-file other)))
          (if (eq? colorq coloro)
              (and (or (not (= rankq ranko))
                       (not (= fileq fileo)))
                   (queen-fits-in? queen (cdr other-queens)))
              (and (not (= rankq ranko))
                   (not (= fileq fileo))
                   (not (= (+ rankq fileq) (+ ranko fileo)))
                   (not (= (- rankq fileq) (- ranko fileo)))
                   (queen-fits-in? queen (cdr other-queens))))))))

(define (latest-queen-fits-in? queens)
  (or (null? (cdr queens))
      (queen-fits-in? (car queens) (cdr queens))))

(define (make-peaceful-queens-generator m n)
  (make-generator-procedure
   (lambda ()
     (define solutions '())

     (let loop ((queens (list (make-queen BLACK 1 1)))
                (num-queens 1))

       (define (add-another-queen)
         (let ((color (reverse-color (queen-color (car queens)))))
           (loop (cons (make-queen color 1 1) queens)
                 (+ num-queens 1))))

       (define (move-a-queen)
         (let drop-one ((queens queens)
                        (num-queens num-queens))
           (if (zero? num-queens)
               (loop '() 0)
               (let* ((latest (car queens))
                      (color (queen-color latest))
                      (rank (queen-rank latest))
                      (file (queen-file latest)))
                 (if (and (= rank n) (= file n))
                     (drop-one (cdr queens) (- num-queens 1))
                     (let-values (((rank^ file^)
                                   (advance-ij n rank file)))
                       (loop (cons (make-queen color rank^ file^)
                                   (cdr queens))
                             num-queens)))))))

       (cond ((zero? num-queens)
              ;; There are no more solutions.
              &fail)

             ((latest-queen-fits-in? queens)
              (if (= num-queens (* 2 m))
                  (let ((board (queens->board queens)))
                    ;; The current "queens" is a solution.
                    (unless (member board solutions board-equiv?)
                      ;; The current "queens" is a *new* solution.
                      (set! solutions (cons board solutions))
                      (suspend queens))
                    (move-a-queen))
                  (add-another-queen)))

             (else
              (move-a-queen)))))))

(define args (command-line))
(unless (or (= (length args) 3)
            (= (length args) 4))
  (display "Usage: ")
  (display (list-ref args 0))
  (display " M N [MAX_SOLUTIONS]")
  (newline)
  (exit 1))
(define m (string->number (list-ref args 1)))
(define n (string->number (list-ref args 2)))
(define max-solutions
  (if (= (length args) 4)
      (string->number (list-ref args 3))
      +inf.0))

(define generate-peaceful-queens
  (make-peaceful-queens-generator m n))

(let loop ((next-solution-number 1))
  (when (<= next-solution-number max-solutions)
    (let ((solution (generate-peaceful-queens)))
      (when (success? solution)
        (display "Solution ")
        (display next-solution-number)
        (newline)
        (display (queens->string n solution))
        (newline)
        (newline)
        (loop (+ next-solution-number 1))))))
