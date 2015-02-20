#lang racket
;; Imperative version: Translation of C
;; Vigenère:           Translation of Pascal
(module+ test (require tests/eli-tester))

;; ---------------------------------------------------------------------------------------------------
;; standard.h: Standard definitions and types, Bob Jenkins
(define UB4MAXVAL #xffffffff)
(define-syntax-rule (bit target mask) (bitwise-and target mask))
;; C-like operators
(define-syntax-rule (u4-truncate x) (bit x UB4MAXVAL))
(define-syntax-rule (u4<< a b)      (u4-truncate (arithmetic-shift a b)))
(define-syntax-rule (u4>> a b)      (u4-truncate (arithmetic-shift a (- b))))
(define-syntax-rule (_++ i)         (let ((rv i)) (set! i (u4-truncate (add1 i))) rv))
(define-syntax-rule (u4+= a b)      (begin (set! a (u4-truncate (+ a b))) a))
(define-syntax-rule (^= a b)        (begin (set! a (u4-truncate (bitwise-xor a b))) a))

;; ---------------------------------------------------------------------------------------------------
;; rand.h: definitions for a random number generator
(define RANDSIZL  8)
(define RANDSIZ   (u4<< 1 RANDSIZL))
(define RANDSIZ-1 (sub1 RANDSIZ))

(struct randctx
  (cnt
   rsl ; RANDSIZ*4 bytes (makes u4's)
   mem ; RANDSIZ*4 bytes (makes u4's)
   a b c) #:mutable)

(define (new-randctx)
  (randctx 0 (make-bytes (* 4 RANDSIZ) 0) (make-bytes (* 4 RANDSIZ) 0) 0 0 0))

(define (bytes->hex-string B (start 0) (end #f) #:join (join "") #:show-bytes? (show-bytes? #f))
  (define hexes
    (for/list ((b (in-bytes B start end)))
      (~a (number->string b 16) #:width 2 #:align 'right #:pad-string "0")))
  (string-join
   (append hexes (if show-bytes?
                     (list " \"" (bytes->string/utf-8 B #f start (or end (bytes-length B))) "\"")
                     null))
   join))

(define format-randctx
  (match-lambda
    [(randctx C (app bytes->hex-string R) (app bytes->hex-string M) a b c)
     (format "randctx: cnt:~a~%rsl:~s~%mem:~s~%a:~a b:~a c:~a" C R M a b c)]))

(define be? (system-big-endian?))

(define (bytes->u4 ary idx)
  (integer-bytes->integer ary #f be? (* idx 4) (* (add1 idx) 4)))

(define (u4->bytes! ary idx v)
  (integer->integer-bytes (bit v UB4MAXVAL) 4 #f be? ary (* idx 4)))

;; ---------------------------------------------------------------------------------------------------
;; rand.c: "By Bob Jenkins.  My random number generator, ISAAC.  Public Domain."
(define (ind mm x)
  (define idx (bitwise-and x (u4<< RANDSIZ-1 2)))
  (integer-bytes->integer mm #f be? idx (+ idx 4)))

(define (isaac C)
  (define M (randctx-mem C))
  (define R (randctx-rsl C))
  (define mm 0)
  (define r  0)
  (define-syntax-rule (rng-step mix)
    (begin
      (define x (bytes->u4 M m))
      (set! a (u4-truncate (+ (bitwise-xor a mix) (bytes->u4 M (_++ m2)))))
      (define y (+ (ind M x) a b))
      (u4->bytes! M (_++ m) y)
      (set! b (u4-truncate (+ (ind M (u4>> y RANDSIZL)) x)))
      (u4->bytes! R (_++ r) b)))

  (define a (randctx-a C))

  (set-randctx-c! C (add1 (randctx-c C)))

  (define b (u4-truncate (+ (randctx-b C) (randctx-c C))))

  (define m mm)
  (define m2 (+ m (/ RANDSIZ 2)))
  (define mend m2)

  (define-syntax-rule (4-step-loop variant)
    (let loop ()
      (when (< variant mend)
        (rng-step (u4<< a 13)) (rng-step (u4>> a 6))
        (rng-step (u4<< a  2)) (rng-step (u4>> a 16))
        (loop))))

  (4-step-loop m)
  (set! m2 mm)
  (4-step-loop m2)

  (set-randctx-b! C b)
  (set-randctx-a! C a))

;; dot infix notation because I'm too lazy to move the operators left!
(define-syntax-rule (mix-line<< A B N D C)
  (begin (A . ^= . (B . u4<< . N)) (D . u4+= . A) (B . u4+= . C)))
(define-syntax-rule (mix-line>> A B N D C)
  (begin (A . ^= . (B . u4>> . N)) (D . u4+= . A) (B . u4+= . C)))

(define-syntax-rule (mix a b c d e f g h)
  (begin (mix-line<< a b 11 d c) (mix-line>> b c  2 e d)
         (mix-line<< c d  8 f e) (mix-line>> d e 16 g f)
         (mix-line<< e f 10 h g) (mix-line>> f g  4 a h)
         (mix-line<< g h  8 b a) (mix-line>> h a  9 c b)))

;; if (flag==TRUE), then use the contents of randrsl[] to initialize mm[].
(define (rand-init C flag?)
  (set-randctx-a! C 0)
  (set-randctx-b! C 0)
  (set-randctx-c! C 0)

  ;; seed-ctx should set these up (with the seed!):
  ;;   (set-ctx-rsl! C (make-bytes (* 4 RANDSIZ) 0))
  ;;   (set-ctx-mem! C (make-bytes (* 4 RANDSIZ) 0))
  (define R (randctx-rsl C))
  (define M (randctx-mem C))

  (define φ #x9e3779b9) ; the golden ratio
  (match-define (list a b c d e f g h) (make-list 8 φ))

  (for ((_ 4)) (mix a b c d e f g h)) ; scramble it

  (define-syntax-rule (mix-and-assign i M2)
    (begin
      (mix a b c d e f g h)
      (u4->bytes! M2 (+ i 0) a) (u4->bytes! M2 (+ i 1) b)
      (u4->bytes! M2 (+ i 2) c) (u4->bytes! M2 (+ i 3) d)
      (u4->bytes! M2 (+ i 4) e) (u4->bytes! M2 (+ i 5) f)
      (u4->bytes! M2 (+ i 6) g) (u4->bytes! M2 (+ i 7) h)))

  (define-syntax-rule (mix-with-mem M1 M2)
    (for ((i (in-range 0 RANDSIZ 8)))
      (a . u4+= . (bytes->u4 M1 (+ i 0))) (b . u4+= . (bytes->u4 M1 (+ i 1)))
      (c . u4+= . (bytes->u4 M1 (+ i 2))) (d . u4+= . (bytes->u4 M1 (+ i 3)))
      (e . u4+= . (bytes->u4 M1 (+ i 4))) (f . u4+= . (bytes->u4 M1 (+ i 5)))
      (g . u4+= . (bytes->u4 M1 (+ i 6))) (h . u4+= . (bytes->u4 M1 (+ i 7)))
      (mix-and-assign i M2)))

  (cond
    [flag? ; initialize using the contents of r[] as the seed
     (mix-with-mem R M)
     (mix-with-mem M M)] ; do a second pass to make all of the seed affect all of m
    [else ; fill in m[] with messy stuff
     (for ((i (in-range 0 RANDSIZ 8))) (mix-and-assign i M))])

  (isaac C)  ; fill in the first set of results
  (set-randctx-cnt! C 0)) ; prepare to use the first set of results

(define (seed-ctx C key #:flag? (flag? #t))
  (bytes-fill! (randctx-mem C) 0)
  (define R (randctx-rsl C))
  (bytes-fill! (randctx-rsl C) 0)
  (for ((k (in-bytes key)) (i (in-range (quotient (bytes-length R) 4)))) (u4->bytes! R i k))
  (rand-init C flag?))

;; Get a random 32-bit value 0..MAXINT
(define (i-random C)
  (define cnt (randctx-cnt C))
  (define r (bytes->u4 (randctx-rsl C) cnt))
  (define cnt+1 (add1 cnt))
  (cond [(>= cnt+1 RANDSIZ) (isaac C) (set-randctx-cnt! C 0)]
        [else (set-randctx-cnt! C cnt+1)])
  r)

;; Get a random character in printable ASCII range
(define ((i-rand-a C))
  (+ 32 (modulo (i-random C) 95)))

(define (Vernham rnd-fn msg)
  (define gsm (make-bytes (bytes-length msg)))
  (for ((i (in-naturals)) (m (in-bytes msg)))
    (define r (rnd-fn))
    (define b (bitwise-xor m r))
    (bytes-set! gsm i b))
  gsm)

;; Get position of the letter in chosen alphabet
;; Caesar-shift a character <shift> places: Generalized Vigenere
(define ((Caesar mod-n start) encrypt? shift ch)
  (define (letter-num letter/byte)
    (- letter/byte (char->integer start)))

  (define shift-fn (if encrypt? + -))
  (+ (char->integer start) (modulo (shift-fn (letter-num ch) shift) mod-n)))

;; Vigenère mod 95 encryption & decryption. Output: bytes
(define Vigenère-Caeser (Caesar 95 #\space))
(define (Vigenère encrypt? rand-fn msg)
  (list->bytes
   (for/list ((b (in-bytes msg)))
     (Vigenère-Caeser encrypt? (rand-fn) b))))

{module+ main
  (define message #"a Top Secret secret")
  (define key     #"this is my secret key")
  (define C (new-randctx))
  (seed-ctx C key)
  (define vern.msg (Vernham (i-rand-a C) message))
  ;; Pascal doesn't reset the context betwen XOR and MOD
  ;; (seed-ctx C key)
  (define vigen.msg (Vigenère #t (i-rand-a C) message))
  (seed-ctx C key)
  (define vern2.msg (Vernham (i-rand-a C) vern.msg))
  ;; Pascal doesn't reset the context betwen XOR and MOD
  ;; (seed-ctx C key)
  (define unvigen.msg (Vigenère #f (i-rand-a C) vigen.msg))
  ;; This is what MOD looks like from the context as seeded with key
  (seed-ctx C key)
  (define vigen-at-seed.msg (Vigenère #t (i-rand-a C) message))
  (seed-ctx C key)
  (define unvigen-at-seed.msg (Vigenère #f (i-rand-a C) vigen-at-seed.msg))

  (printf #<<EOS
Message:            [~a]
Key:                [~a]

                    < context reseeded
Vernham (XOR):      [~a]
Vigenère (MOD):     [~a]

                    < context reseeded
Vernham (XOR(XOR)): [~a]
Vigenère (-MOD):    [~a]

                    < context reseeded (different to Pascal Vigenère encryption)
Vigenère (MOD):     [~a]
                    < context reseeded
Vigenère (-MOD):    [~a]
EOS
          message
          key
          (bytes->hex-string vern.msg)
          (bytes->hex-string vigen.msg #:show-bytes? #t)
          (bytes->hex-string vern2.msg #:show-bytes? #t)
          (bytes->hex-string unvigen.msg #:show-bytes? #t)
          (bytes->hex-string vigen-at-seed.msg #:show-bytes? #t)
          (bytes->hex-string unvigen-at-seed.msg #:show-bytes? #t)
          )}

{module+ test
  ;; "If the initial internal state is all zero, after ten calls the values of aa, bb, and cc in
  ;; hexadecimal will be d4d3f473, 902c0691, and 0000000a."
  (let ()
    (define C (new-randctx))
    (for ((_ 10)) (isaac C))
    (test (randctx-a C) => #xd4d3f473
          (randctx-b C) => #x902c0691
          (randctx-c C) => 10))
  }
