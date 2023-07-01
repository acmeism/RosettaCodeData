;;;
;;; Solutions to the Peaceful Chess Queen Armies puzzle, in R7RS
;;; Scheme (using also SRFI-132).
;;;
;;; https://rosettacode.org/wiki/Peaceful_chess_queen_armies
;;;

(cond-expand
  (r7rs)
  (chicken (import (r7rs))))

(import (scheme process-context))
(import (only (srfi 132) list-sort))

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

(define BLACK 'B)
(define WHITE 'W)

(define (flip-color c)
  (if (eq? c BLACK) WHITE BLACK))

(define-record-type <queen>
  (make-queen color rank file)
  queen?
  (color queen-color)
  (rank queen-rank)
  (file queen-file))

(define (serialize-queen queen)
  (string-append (if (eq? (queen-color queen) BLACK) "B" "W")
                 "(" (number->string (queen-rank queen))
                 "," (number->string (queen-file queen)) ")"))

(define (serialize-queens queens)
  (apply string-append
         (list-sort string<? (map serialize-queen queens))))

(define (queens->string n queens)

  (define board
    (let ((board (make-vector (* n n) #f)))
      (do ((q queens (cdr q)))
          ((null? q))
        (let* ((color (queen-color (car q)))
               (i (queen-rank (car q)))
               (j (queen-file (car q))))
          (vector-set! board (ij->index n i j) color)))
      board))

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
         (let ((color (flip-color (queen-color (car queens)))))
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
                  (let ((str (serialize-queens queens)))
                    ;; The current "queens" is a solution.
                    (unless (member str solutions)
                      ;; The current "queens" is a *new* solution.
                      (set! solutions (cons str solutions))
                      (suspend queens))
                    (move-a-queen))
                  (add-another-queen)))

             (else
              (move-a-queen)))))))

(define (ij->index n i j)
  (let ((i1 (- i 1))
        (j1 (- j 1)))
    (+ i1 (* n j1))))

(define (index->ij n index)
  (let-values (((q r) (floor/ index n)))
    (values (+ r 1) (+ q 1))))

(define (advance-ij n i j)
  (index->ij n (+ (ij->index n i j) 1)))

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
