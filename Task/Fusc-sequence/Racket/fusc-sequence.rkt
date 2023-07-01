#lang racket

(require racket/generator)

(define (memoize f)
  (define table (make-hash))
  (λ args (hash-ref! table args (thunk (apply f args)))))

(define fusc
  (memoize
   (λ (n)
     (cond
       [(<= n 1) n]
       [(even? n) (fusc (/ n 2))]
       [else (+ (fusc (/ (sub1 n) 2)) (fusc (/ (add1 n) 2)))]))))

(define (comma x)
  (string-join
   (reverse
    (for/list ([digit (in-list (reverse (string->list (~a x))))] [i (in-naturals)])
      (cond
        [(and (= 0 (modulo i 3)) (> i 0)) (string digit #\,)]
        [else (string digit)])))
   ""))

;; Task 1
(displayln (string-join (for/list ([i (in-range 61)]) (comma (fusc i))) " "))
(newline)

;; Task 2
(define gen
  (in-generator
   (let loop ([prev 0] [i 0])
     (define result (fusc i))
     (define len (string-length (~a result)))
     (cond
       [(> len prev)
        (yield (list i result))
        (loop len (add1 i))]
       [else (loop prev (add1 i))]))))

(for ([i (in-range 5)] [x gen])
  (match-define (list index result) x)
  (printf "~a: ~a\n" (comma index) (comma result)))
