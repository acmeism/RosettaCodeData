(cond-expand
  (r7rs)
  (chicken (import r7rs)))

(import (scheme base))
(import (scheme inexact))
(import (scheme write))
(import (only (srfi 1) delete))
(import (only (srfi 1) iota))
(import (srfi 27))                      ; Random numbers.

;;
;; The following import is CHICKEN-specific, but your Scheme likely
;; has Common Lisp formatting somewhere.
;;
(import (format))                       ; Common Lisp formatting.

;;
;; You can do without SRFI-143 or SRFI-144 by changing fx+ or fl+ to
;; +, etc.
;;
(import (srfi 143))                     ; Optimizations for fixnums.
(import (srfi 144))                     ; Optimizations for flonums.

(random-source-randomize! default-random-source)

(define (n->ij n)
  (values (fxquotient n 10)
          (fxremainder n 10)))

(define (ij->n i j)
  (fx+ (fx* 10 i) j))

(define neighbor-offsets
  '((0 . 1)
    (1 . 0)
    (1 . 1)
    (0 . -1)
    (-1 . 0)
    (-1 . -1)
    (1 . -1)
    (-1 . 1)))

(define (neighborhood n)
  (let-values (((i j) (n->ij n)))
    (let recurs ((offsets neighbor-offsets))
      (if (null? offsets)
          '()
          (let* ((offs (car offsets))
                 (i^ (fx+ i (car offs)))
                 (j^ (fx+ j (cdr offs))))
            (if (and (not (fxnegative? i^))
                     (not (fxnegative? j^))
                     (fx<? i^ 10)
                     (fx<? j^ 10))
                (cons (ij->n i^ j^) (recurs (cdr offsets)))
                (recurs (cdr offsets))))))))

(define (distance**2 m n)
  (let-values (((im jm) (n->ij m))
               ((in jn) (n->ij n)))
    (fx+ (fxsquare (fx- im in)) (fxsquare (fx- jm jn)))))

(define (shuffle! vec i n)
  ;; A Fisher-Yates shuffle of n elements of vec, starting at index i.
  (do ((j 0 (+ j 1)))
      ((= j n))
    (let* ((k (+ i j (random-integer (- n j))))
           (xi (vector-ref vec i))
           (xk (vector-ref vec k)))
      (vector-set! vec i xk)
      (vector-set! vec k xi))))

(define (make-s0)
  (let ((vec (list->vector (iota 100))))
    (shuffle! vec 1 99)
    vec))

(define (swap-s-elements! vec u v)
  (let loop ((j 1)
             (iu 0)
             (iv 0))
    (cond ((fxpositive? iu)
           (if (fx=? (vector-ref vec j) v)
               (begin (vector-set! vec iu v)
                      (vector-set! vec j u))
               (loop (fx+ j 1) iu iv)))
          ((fxpositive? iv)
           (if (fx=? (vector-ref vec j) u)
               (begin (vector-set! vec j v)
                      (vector-set! vec iv u))
               (loop (fx+ j 1) iu iv)))
          ((fx=? (vector-ref vec j) u) (loop (fx+ j 1) j 0))
          ((fx=? (vector-ref vec j) v) (loop (fx+ j 1) 0 j))
          (else (loop (fx+ j 1) 0 0)))))

(define (update-s! vec)
  (let* ((u (fx+ 1 (random-integer 99)))
         (neighbors (delete 0 (neighborhood u) fx=?))
         (n (length neighbors))
         (v (list-ref neighbors (random-integer n))))
    (swap-s-elements! vec u v)))

(define (s->s vec)                      ; s_k -> s_(k + 1)
  (let ((vec^ (vector-copy vec)))
    (update-s! vec^)
    vec^))

(define (path-length vec)
  (let loop ((plen (flsqrt (inexact
                            (distance**2 (vector-ref vec 0)
                                         (vector-ref vec 99)))))
             (x (vector-ref vec 0))
             (i 1))
    (if (fx=? i 100)
        plen
        (let ((y (vector-ref vec i)))
          (loop (fl+ plen (flsqrt (inexact (distance**2 x y))))
                y (fx+ i 1))))))

(define (E_s vec)
  (let loop ((E (distance**2 (vector-ref vec 0)
                             (vector-ref vec 99)))
             (x (vector-ref vec 0))
             (i 1))
    (if (fx=? i 100)
        E
        (let ((y (vector-ref vec i)))
          (loop (fx+ E (distance**2 x y)) y (fx+ i 1))))))

(define (make-temperature-procedure kT kmax)
  (let ((kT (inexact kT))
        (kmax (inexact kmax)))
    (lambda (k)
      (fl* kT (fl- 1.0 (fl/ (inexact k) kmax))))))

(define (probability delta-E T)
  (if (fxnegative? delta-E)
      1.0
      (if (flzero? T)
          0.0
          (flexp (fl- (fl/ (inexact delta-E) T))))))

(define fmt10 (string-append
               "       k       T     E(s)    path length~%"
               " ---------------------------------------~%"))
(define fmt20 " ~7D ~7,2F ~8D ~14,5F~%")

(define (simulate-annealing kT kmax)
  (let* ((temperature (make-temperature-procedure kT kmax))
         (s0 (make-s0))
         (E0 (E_s s0))
         (kmax/10 (fxquotient kmax 10))
         (show (lambda (k T E s)
                 (when (fxzero? (fxremainder k kmax/10))
                   (format #t fmt20 k T E (path-length s))))))
    (format #t fmt10)
    (let loop ((k 0)
               (s s0)
               (E E0))
      (if (fx=? k (fx+ 1 kmax))
          s
          (let* ((T (temperature k))
                 (_ (show k T E s))
                 (s^ (s->s s))
                 (E^ (E_s s^))
                 (delta-E (fx- E^ E))
                 (P (probability delta-E T)))
            (if (or (fl=? P 1.0) (fl<=? (random-real) P))
                (loop (fx+ k 1) s^ E^)
                (loop (fx+ k 1) s E)))))))

(define (display-path vec)
  (do ((i 0 (+ i 1)))
      ((= i 100))
    (let ((x (vector-ref vec i)))
      (when (< x 10)
        (display " "))
      (display x)
      (display " -> ")
      (when (= 7 (truncate-remainder i 8))
        (newline))))
  (let ((x (vector-ref vec 0)))
    (when (< x 10)
      (display " "))
    (display x)))

(define kT 1.5)
(define kmax 2000000)

(newline)
(display "   kT: ")
(display kT)
(newline)
(display "   kmax: ")
(display kmax)
(newline)
(newline)
(define s-final (simulate-annealing kT kmax))
(newline)
(display "Final path:")
(newline)
(display-path s-final)
(newline)
(newline)
(format #t "Final E(s): ~,5F~%" (E_s s-final))
(format #t "Final path length: ~,5F~%" (path-length s-final))
(newline)
