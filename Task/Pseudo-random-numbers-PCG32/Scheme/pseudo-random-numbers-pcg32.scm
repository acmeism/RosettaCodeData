(import (scheme small) (srfi 33))

(define PCG-DEFAULT-MULTIPLIER 6364136223846793005)
(define MASK64 (- (arithmetic-shift 1 64) 1))
(define MASK32 (- (arithmetic-shift 1 32) 1))

(define-record-type <pcg32-random> (make-pcg32-random-record) pcg32?
  (state pcg32-state pcg32-state!)
  (inc   pcg32-inc   pcg32-inc!))

(define (make-pcg32)
  (define rng (make-pcg32-random-record))
  (pcg32-seed rng 31415926 535897932)
  rng)

(define (pcg32-seed rng init-state init-seq)
  (pcg32-state! rng 0)
  (pcg32-inc!   rng
    (bitwise-and
      (bitwise-ior (arithmetic-shift init-seq 1) 1)
      MASK64))
  (pcg32-next-int rng)
  (pcg32-state! rng (bitwise-and (+ (pcg32-state rng) init-state) MASK64))
  (pcg32-next-int rng))

(define (pcg32-next-int rng)
  (define xorshifted 0)
  (define rot        0)
  (define answer     0)
  (define oldstate (pcg32-state rng))
  (pcg32-state! rng
    (bitwise-and
      (+ (* oldstate PCG-DEFAULT-MULTIPLIER) (pcg32-inc rng))
      MASK64))
  (set! xorshifted  (bitwise-xor (arithmetic-shift oldstate -18) oldstate))
  (set! xorshifted  (arithmetic-shift xorshifted -27))
  (set! xorshifted  (bitwise-and xorshifted MASK32))
  (set! rot (bitwise-and (arithmetic-shift oldstate -59) MASK32))
  (set! answer (bitwise-ior
    (arithmetic-shift xorshifted (- rot))
    (arithmetic-shift xorshifted (bitwise-and (- rot) 31))))
  (set! answer (bitwise-and answer MASK32))
  answer)

(define (pcg32-next-float rng)
  (inexact (/ (pcg32-next-int rng) (arithmetic-shift 1 32))))

;; task

(define rng (make-pcg32))
(pcg32-seed rng 42 54)
(let lp ((i 0)) (when (< i 5)
  (display (pcg32-next-int rng))(newline)
  (lp (+ i 1))))
(newline)

(pcg32-seed rng 987654321 1)
(define vec (make-vector 5 0))
(let lp ((i 0)) (when (< i 100000)
  (let ((j (exact (floor (* (pcg32-next-float rng) 5)))))
    (vector-set! vec j (+ (vector-ref vec j) 1)))
  (lp (+ i 1))))
(let lp ((i 0)) (when (< i 5)
  (display i)
  (display " : ")
  (display (vector-ref vec i))
  (newline)
  (lp (+ i 1))))
