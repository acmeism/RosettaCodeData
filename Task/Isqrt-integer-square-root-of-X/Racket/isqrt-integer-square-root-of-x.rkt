#lang racket

;; Integer Square Root (using Quadratic Residue)
(define (isqrt x)
  (define q-init       ; power of 4 greater than x
    (let loop ([acc 1])
      (if (<= acc x) (loop (* acc 4)) acc)))

  (define-values (z r q)
    (let loop ([z x] [r 0] [q q-init])
      (if (<= q 1)
          (values z r q)
          (let* ([q (/ q 4)]
                 [t (- z r q)]
                 [r (/ r 2)])
            (if (>= t 0)
                (loop t (+ r q) q)
                (loop z r q))))))

  r)

(define (format-with-commas str #:chunk-size [size 3])
  (define len (string-length str))
  (define len-mod (modulo len size))
  (define chunks
    (for/list ([i (in-range len-mod len size)])
           (substring str i (+ i size))))
  (string-join (if (= len-mod 0)
                   chunks
                   (cons (substring str 0 len-mod) chunks))
               ","))

(displayln "Isqrt of integers (0 -> 65):")
(for ([i 66])
  (printf "~a " (isqrt i)))

(displayln "\n\nIsqrt of odd powers of 7 (7 -> 7^73):")
(for/fold ([num 7]) ([i (in-range 1 74 2)])
  (printf "Isqrt(7^~a) = ~a\n"
          i
          (format-with-commas (number->string (isqrt num))))
  (* num 49))
