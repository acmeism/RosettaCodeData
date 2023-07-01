#lang racket

(require racket/generator
         syntax/parse/define)

(define-syntax-parser for**
  [(_ [x:id {~datum <-} (e ...)] rst ...) #'(e ... (λ (x) (for** rst ...)))]
  [(_ e ...) #'(begin e ...)])

(define (permutations xs n yield #:lower [lower #f])
  (let loop ([xs xs] [n n] [acc '()] [lower lower])
    (cond
      [(= n 0) (yield (reverse acc))]
      [else (for ([x (in-list xs)] #:when (or (not lower) (>= x (first lower))))
              (loop (remove x xs)
                    (sub1 n)
                    (cons x acc)
                    (and lower (= x (first lower)) (rest lower))))])))

(define (list->number xs) (foldl (λ (e acc) (+ (* 10 acc) e)) 0 xs))

(define (calc n)
  (define rng (range 1 10))
  (in-generator
   (for** [numer <- (permutations rng n)]
          [denom <- (permutations rng n #:lower numer)]
          (for* (#:when (not (equal? numer denom))
                 [crossed (in-list numer)]
                 #:when (member crossed denom)
                 [numer* (in-value (list->number (remove crossed numer)))]
                 [denom* (in-value (list->number (remove crossed denom)))]
                 [numer** (in-value (list->number numer))]
                 [denom** (in-value (list->number denom))]
                 #:when (= (* numer** denom*) (* numer* denom**)))
            (yield (list numer** denom** numer* denom* crossed))))))

(define (enumerate n)
  (for ([x (calc n)] [i (in-range 12)])
    (apply printf "~a/~a = ~a/~a (~a crossed out)\n" x))
  (newline))

(define (stats n)
  (define digits (make-hash))
  (for ([x (calc n)]) (hash-update! digits (last x) add1 0))
  (printf "There are ~a ~a-digit fractions of which:\n" (for/sum ([(k v) (in-hash digits)]) v) n)
  (for ([digit (in-list (sort (hash->list digits) < #:key car))])
    (printf "  The digit ~a was crossed out ~a times\n" (car digit) (cdr digit)))
  (newline))

(define (main)
  (enumerate 2)
  (enumerate 3)
  (enumerate 4)
  (enumerate 5)
  (stats 2)
  (stats 3)
  (stats 4)
  (stats 5))

(main)
