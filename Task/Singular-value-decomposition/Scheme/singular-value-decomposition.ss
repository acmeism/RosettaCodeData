;; This is code I wrote mostly in 2021.
;;
;; No doubt the code can be made faster for Scheme, by for instance
;; reducing the use of ‘set!’. That has sometimes seemed to help, at
;; least with some Scheme implementations. But the code should at
;; least work.
;;
;; If you are doing heavy duty vector processing, though, interface to
;; LAPACK instead. :)

;;
;; The Golub-Reinsch algorithm for the singular value decomposition,
;; based mostly on the EISPACK implementation.
;;
;; References:
;;
;;   [1] G.H. Golub and C. Reinsch. 1970. Singular value decomposition
;;       and least squares solutions. Numer. Math. 14 (1970),
;;       403–420. DOI: https://doi.org/10.1007/BF02163027
;;
;;   [2] EISPACK. https://www.netlib.org/eispack/
;;

(define-library (svd)

  (export svd)

  (import (scheme base))

  ;; This is part of R7RS-large, under the name (scheme sort).
  (import (srfi 132))                   ; Sorting.

  ;; These two are part of R7RS-large, under the names (scheme fixnum)
  ;; and (scheme flonum).
  (import (srfi 143))                   ; Fixnums.
  (import (srfi 144))                   ; Flonums.

  ;;
  ;; Arrays are not yet standardized in R7RS-large. I wrote this code
  ;; for CHICKEN Scheme, which supported SRFI-179 via an ‘egg’. So I
  ;; use SRFI-179. But SRFI-179 is not currently supported in Gauche
  ;; Scheme. Thus this code, as written, will not work in Gauche.
  ;;
  ;; Gauche DOES have ‘specialized arrays’, but they do not conform to
  ;; SRFI-179. At the time of this writing (10 May 2023), neither
  ;; CHICKEN nor Gauche supports SRFI-231 (a revision of SRFI-179), or
  ;; I would have switched to that.
  ;;
  ;; Arrays are on the docket for R7RS-large Orange edition:
  ;; https://github.com/johnwcowan/r7rs-work/blob/master/ColorDockets.md#user-content-orange-docket-portable-srfis
  ;;
  (import (srfi 179))                   ; Arrays.

  ;; SRFI-42 is not part of any Scheme standard, but is widely
  ;; supported. Both CHICKEN and Gauche support it.
  (import (srfi 42))                    ; Eager comprehensions.

  (begin

    (define (flpythag a b)
      ;;
      ;; Find sqrt(a**2+b**2) without overflow or destructive
      ;; underflow.
      ;;
      ;; Based on the EISPACK function PYTHAG(A,B).
      ;;
      (let* ((abs-a (flabs a))
             (abs-b (flabs b))
             (p (flmax abs-a abs-b)))
        (if (fl=? p 0.0)
            p
            (let ((sqrt-r (fl/ (flmin abs-a abs-b) p)))
              (let loop ((p p)
                         (r (* sqrt-r sqrt-r)))
                (let ((t (fl+ 4.0 r)))
                  (if (fl=? t 4.0)
                      p
                      (let* ((s (fl/ r t))
                             (u (fl+ 1.0 (fl* 2.0 s)))
                             (p (fl* u p))
                             (s/u (fl/ s u))
                             (r (fl* (fl* s/u s/u) r)))
                        (loop p r)))))))))


    (define svd-based-on-eispack-maximum-iterations
      (make-parameter 30 (lambda (n)
                           (and (fixnum? n) (fxpositive? n)))))

    (define (svd-based-on-eispack A with-U? with-V?)
      ;;
      ;; Computes the singular value decomposition A = UΣVᵀ of a real
      ;; matrix A, as implemented in EISPACK, where A and U are m×n, Σ
      ;; and V are n×n. The algorithm is based on that of Golub and
      ;; Reinsch.
      ;;
      ;; UᵀU = VᵀV = VVᵀ = I, the n×n identity matrix.
      ;;
      ;; Σ is a diagonal matrix of the singular values (the
      ;; non-negative square roots of the eigenvalues of AᵀA). In
      ;; addition, U comprises orthonormalized eigenvectors associated
      ;; with the n largest eigenvalues of AAᵀ, and V comprises the
      ;; orthonormalized eigenvectors of AᵀA.
      ;;
      ;; The input array A is assumed to be a two-dimensional SRFI-179
      ;; array. The array is not modified, and the rows and columns
      ;; can be indexed starting at zero or one or however you like.
      ;;
      ;; So, for example, if there are to be m rows and n columns,
      ;; this will do:
      ;;
      ;;   (make-specialized-array
      ;;    (make-interval #(1 1) (vector (fx+ m 1) (fx+ n 1)))
      ;;    f64-storage-class)
      ;;
      ;; The return values are
      ;;
      ;;   (values ierr w U V)
      ;;
      ;; If ierr=0, then the procedure succeeded; otherwise ierr=k
      ;; where convergence failed while computing the kth singular
      ;; value.
      ;;
      ;; w is a single-dimensional f64-storage-class SRFI-179 array of
      ;; the singular values, indexed 1..n. It is the diagonal of
      ;; Σ. Note that the singular values are *not* sorted by size;
      ;; neither are they set to zero if below some threshold.
      ;;
      ;; If with-U? is #f, then U is #f. Otherwise it is a
      ;; two-dimensional f64-storage-class SRFI-179 array of the
      ;; matrix U, indexed 1..m,1..n.
      ;;
      ;; If with-V? is #f, then V is #f. Otherwise it is a
      ;; two-dimensional f64-storage-class SRFI-179 array of the
      ;; matrix V, indexed 1..n,1..n.
      ;;

      (define (svd A m n)

        (define (flsign a b)
          ;; Do what the SIGN function does in Fortran: if 0 <= b then
          ;; return abs(a), else -abs(a).
          (if (fl<=? 0.0 b)
              (flabs a)
              (fl- (flabs a))))

        (define m+1 (fx+ m 1))
        (define n+1 (fx+ n 1))

        ;; Some intervals.
        (define 1:n (make-interval #(1) (vector n+1)))
        (define 1:n×1:n (make-interval #(1 1) (vector n+1 n+1)))

        ;; The singular values.
        (define w (make-specialized-array 1:n f64-storage-class))

        ;; The left-hand result matrix, or workspace if the left-hand
        ;; matrix is not requested.
        (define U (array-copy A f64-storage-class #f #t))

        ;; The right-hand result matrix, if requested.
        (define V (if with-V?
                      (make-specialized-array 1:n×1:n f64-storage-class)
                      #f))

        ;; Some workspace.
        (define rv1 (make-specialized-array 1:n f64-storage-class))

        ;; Flonum variables.
        (define c 0.0)
        (define f 0.0)
        (define g 0.0)
        (define h 0.0)
        (define s 0.0)
        (define x 0.0)
        (define y 0.0)
        (define z 0.0)
        (define scale 0.0)

        ;; The maximum number of iterations.
        (define maxit (svd-based-on-eispack-maximum-iterations))

        ;; Fixnum variables.
        (define l 0)

        (define (results ierr w U V)
          (values ierr w (and with-U? U) (and with-V? V)))

        (define (test-for-convergence iterations tst1 k l)
          (define k1 (fx- k 1))
          ;;
          ;; Test for convergence.
          ;;
          (set! z (array-ref w k))
          (if (fx=? l k)
              (begin
                ;;
                ;; Convergence succeeded.
                ;;
                (unless (fl<=? 0.0 z)
                  ;; w(k) is made non-negative.
                  (array-set! w (fl- z) k)
                  (when with-V?
                    (do-ec (:range j 1 n+1)
                      (array-set! V (fl- (array-ref V j k)) j k))))
                (diagonalization tst1 (fx- k 1)))
              (begin
                ;; Shift from bottom 2-by-2 minor.
                (cond
                 ((fx=? iterations maxit)
                  ;;
                  ;; Convergence failed.
                  ;;
                  (results k w U V))
                 (else
                  (set! iterations (fx+ iterations 1))
                  (set! x (array-ref w l))
                  (set! y (array-ref w k1))
                  (set! g (array-ref rv1 k1))
                  (set! h (array-ref rv1 k))
                  (set! f (fl* 0.5
                               (fl- (fl+ (fl* (fl/ (fl+ g z) h)
                                              (fl/ (fl- g z) y))
                                         (fl/ y h))
                                    (fl/ h y))))
                  (set! g (flpythag f 1.0))
                  (set! f (fl+ (fl- x (fl* (fl/ z x) z))
                               (fl* (fl/ h x)
                                    (fl- (fl/ y (fl+ f (flsign g f)))
                                         h))))
                  ;;
                  ;; The next QR transformation.
                  ;;
                  (set! c 1.0)
                  (set! s 1.0)
                  (do-ec (:range i1 l k)
                    (let ((i (fx+ i1 1)))
                      (set! g (array-ref rv1 i))
                      (set! y (array-ref w i))
                      (set! h (fl* s g))
                      (set! g (fl* c g))
                      (set! z (flpythag f h))
                      (array-set! rv1 z i1)
                      (set! c (fl/ f z))
                      (set! s (fl/ h z))
                      (set! f (fl+ (fl* g s) (fl* x c)))
                      (set! g (fl- (fl* g c) (fl* x s)))
                      (set! h (fl* y s))
                      (set! y (fl* y c))
                      (when with-V?
                        (do-ec (:range j 1 n+1)
                          (begin
                            (set! x (array-ref V j i1))
                            (set! z (array-ref V j i))
                            (array-set! V (fl+ (fl* z s) (fl* x c))
                                        j i1)
                            (array-set! V (fl- (fl* z c) (fl* x s))
                                        j i))))
                      (set! z (flpythag f h))
                      (array-set! w z i1)
                      (unless (fl=? z 0.0)
                        ;; Rotation can be arbitrary if z is zero.
                        (set! c (fl/ f z))
                        (set! s (fl/ h z)))
                      (set! f (fl+ (fl* s y) (fl* c g)))
                      (set! x (fl- (fl* c y) (fl* s g)))
                      (when with-U?
                        (do-ec (:range j 1 m+1)
                          (begin
                            (set! y (array-ref U j i1))
                            (set! z (array-ref U j i))
                            (array-set! U (fl+ (fl* z s) (fl* y c))
                                        j i1)
                            (array-set! U (fl- (fl* z c) (fl* y s))
                                        j i)))) ))
                  (array-set! rv1 0.0 l)
                  (array-set! rv1 f k)
                  (array-set! w x k)
                  (test-for-splitting iterations tst1 k))))))

        (define (cancellation iterations tst1 k l)
          (define l1 (fx- l 1))
          ;;
          ;; Cancellation of rv1(l) if l > 1.
          ;;
          (set! c 0.0)
          (set! s 1.0)
          (do-ec (:range i l (fx+ k 1))
            (let ((rv1@i (array-ref rv1 i)))
              (set! f (fl* s rv1@i))
              (array-set! rv1 (fl* c rv1@i) i)
              (if (fl=? (fl+ tst1 (flabs f)) tst1)
                  (test-for-convergence iterations k l)
                  (begin
                    (set! g (array-ref w i))
                    (set! h (flpythag f g))
                    (array-set! w h i)
                    (set! c (fl/ g h))
                    (set! s (fl/ (fl- f) h))
                    (when with-U?
                      (do-ec (:range j 1 m+1)
                        (begin
                          (set! y (array-ref U j l1))
                          (set! z (array-ref U j i))
                          (array-set! U (fl+ (fl* z s) (fl* y c))
                                      j l1)
                          (array-set! U (fl- (fl* z c) (fl* y s))
                                      j i))))))))
          (test-for-convergence iterations tst1 k l))

        (define (test-for-splitting iterations tst1 k)
          ;;
          ;; Test for splitting.
          ;;
          (let loop ((l k))
            (cond ((fx=? l 0)
                   ;; rv1(1) is always zero; therefore l never reaches
                   ;; zero.
                   (error 'svd-based-on-eispack
                          (string-append
                           "THERE IS A BUG: "
                           "this branch should never have been run")))
                  ((fl=? (fl+ tst1 (flabs (array-ref rv1 l)))
                         tst1)
                   (test-for-convergence iterations tst1 k l))
                  ((fl=? (fl+ tst1 (flabs (array-ref w (fx- l 1))))
                         tst1)
                   (cancellation iterations tst1 k l))
                  (else
                   (loop (fx- l 1))))))

        (define (diagonalization tst1 k)
          ;;
          ;; Diagonalization of the bidiagonal form.
          ;;
          (if (fx=? k 0)
              (results 0 w U V)
              (test-for-splitting 0 tst1 k)))

        ;;
        ;; Householder reduction to bidiagonal form.
        ;;
        (set! g 0.0)
        (set! scale 0.0)
        (set! x 0.0)
        (do-ec (:range i 1 n+1)
          (begin
            (set! l (fx+ i 1))
            (array-set! rv1 (fl* scale g) i)
            (set! g 0.0)
            (set! s 0.0)
            (set! scale 0.0)
            (unless (fx<? m i)
              (do-ec (:range k i m+1)
                (set! scale (fl+ scale (flabs (array-ref U k i)))))
              (unless (fl=? scale 0.0)
                (do-ec (:range k i m+1)
                  (let ((U@ki (fl/ (array-ref U k i) scale)))
                    (array-set! U U@ki k i)
                    (set! s (fl+ s (fl* U@ki U@ki)))))
                (set! f (array-ref U i i))
                (set! g (fl- (flsign (flsqrt s) f)))
                (set! h (fl- (fl* f g) s))
                (array-set! U (fl- f g) i i)
                (unless (fx=? i n)
                  (do-ec (:range j l n+1)
                    (begin
                      (set! s 0.0)
                      (do-ec (:range k i m+1)
                        (set! s (fl+ s (fl* (array-ref U k i)
                                            (array-ref U k j)))))
                      (set! f (fl/ s h))
                      (do-ec (:range k i m+1)
                        (array-set! U (fl+ (array-ref U k j)
                                           (fl* f (array-ref U k i)))
                                    k j))))
                  ) ;; end (unless (fx=? i n) ...)
                (do-ec (:range k i m+1)
                  (array-set! U (fl* scale (array-ref U k i)) k i))
                ) ;; end (unless (fl=? scale 0.0) ...)
              )   ;; end (unless (fx<? m i) ...)
            (array-set! w (fl* scale g) i)
            (set! g 0.0)
            (set! s 0.0)
            (set! scale 0.0)
            (unless (or (fx<? m i) (fx=? i n))
              (do-ec (:range k l n+1)
                (set! scale (fl+ scale (flabs (array-ref U i k)))))
              (unless (fl=? scale 0.0)
                (do-ec (:range k l n+1)
                  (let ((U@ik (fl/ (array-ref U i k) scale)))
                    (array-set! U U@ik i k)
                    (set! s (fl+ s (fl* U@ik U@ik)))))
                (set! f (array-ref U i l))
                (set! g (fl- (flsign (flsqrt s) f)))
                (set! h (fl- (fl* f g) s))
                (array-set! U (fl- f g) i l)
                (do-ec (:range k l n+1)
                  (array-set! rv1 (fl/ (array-ref U i k) h) k))
                (unless (fx=? i m)
                  (do-ec (:range j l m+1)
                    (begin
                      (set! s 0.0)
                      (do-ec (:range k l n+1)
                        (set! s (fl+ s (fl* (array-ref U j k)
                                            (array-ref U i k)))))
                      (do-ec (:range k l n+1)
                        (array-set! U (fl+ (array-ref U j k)
                                           (fl* s (array-ref rv1 k)))
                                    j k))))
                  ) ;; end (unless (fx=? i m) ... )
                (do-ec (:range k l n+1)
                  (array-set! U (fl* scale (array-ref U i k)) i k))
                ) ;; end (unless (fl=? scale 0.0) ... )
              )   ;; end (unless (or (fx<? m i) (fx=? i n)) ... )
            (set! x (flmax x (fl+ (flabs (array-ref w i))
                                  (flabs (array-ref rv1 i))))))
          ) ;; end (do-ec (:range i 1 n+1) ... )

        ;;
        ;; Accumulation of right-hand transformations.
        ;;
        (when with-V?
          (do-ec (:range i n 0 -1)
            (begin
              (unless (fx=? i n)
                (unless (fl=? g 0.0)
                  (do-ec (:range j l n+1)
                    ;; The double division avoids a possible underflow.
                    (array-set! V (fl/ (fl/ (array-ref U i j)
                                            (array-ref U i l))
                                       g)
                                j i))
                  (do-ec (:range j l n+1)
                    (begin
                      (set! s 0.0)
                      (do-ec (:range k l n+1)
                        (set! s (fl+ s (fl* (array-ref U i k)
                                            (array-ref V k j)))))
                      (do-ec (:range k l n+1)
                        (array-set! V (fl+ (array-ref V k j)
                                           (fl* s (array-ref V k i)))
                                    k j)))))
                (do-ec (:range j l n+1)
                  (begin
                    (array-set! V 0.0 i j)
                    (array-set! V 0.0 j i))))
              (array-set! V 1.0 i i)
              (set! g (array-ref rv1 i))
              (set! l i))))

        ;;
        ;; Accumulation of left-hand transformations.
        ;;
        (when with-U?
          (do-ec (:range i (fxmin m n) 0 -1)
            (begin
              (set! l (fx+ i 1))
              (set! g (array-ref w i))
              (unless (fx=? i n)
                (do-ec (:range j l n+1)
                  (array-set! U 0.0 i j)))
              (if (fl=? g 0.0)
                  (do-ec (:range j i m+1)
                    (array-set! U 0.0 j i))
                  (begin
                    (unless (fx=? i (fxmin m n))
                      (do-ec (:range j l n+1)
                        (begin
                          (set! s 0.0)
                          (do-ec (:range k l m+1)
                            (set! s (fl+ s (fl* (array-ref U k i)
                                                (array-ref U k j)))))
                          ;; The double division avoids a possible
                          ;; underflow.
                          (set! f (fl/ (fl/ s (array-ref U i i)) g))
                          (do-ec (:range k i m+1)
                            (array-set!
                             U (fl+ (array-ref U k j)
                                    (fl* f (array-ref U k i)))
                             k j))) ))
                    (do-ec (:range j i m+1)
                      (array-set! U (fl/ (array-ref U j i) g) j i))))
              (array-set! U (fl+ (array-ref U i i) 1.0) i i) )))

        (diagonalization x n)

        ) ;; end of procedure svd.

      (let* ((domain_A (array-domain A))

             (i^_min (interval-lower-bound domain_A 0))
             (i^_max+1 (interval-upper-bound domain_A 0))

             (j^_min (interval-lower-bound domain_A 1))
             (j^_max+1 (interval-upper-bound domain_A 1))

             ;; m and n.
             (m (fx- i^_max+1 i^_min))
             (n (fx- j^_max+1 j^_min))

             ;; Reindex A, if necessary.
             (A (if (and (fx=? i^_min 1) (fx=? j^_min 1))
                    A
                    (let ((getter^ (array-getter A))
                          (i^_min-1 (fx- i^_min 1))
                          (j^_min-1 (fx- j^_min 1)))
                      (make-array
                       (make-interval #(1 1) (vector (fx+ m 1)
                                                     (fx+ n 1)))
                       (lambda (i j)
                         (getter^ (fx+ i i^_min-1)
                                  (fx+ j j^_min-1))))))))

        (svd A m n)))

    (define (sort-svd w U V)
      ;;
      ;; Sort w and the optional U and V in order of descending size
      ;; of the singular value. The reordered arrays are new (and
      ;; read-only), but share their storage space with the originals.
      ;;
      ;; FIXME: I tried to use ‘vector-sort!’ instead of
      ;;        ‘vector-stable-sort!’, but, at the time of this
      ;;        writing (9 Mar 2021), it seemed to be broken for the
      ;;        compiler I was using.
      ;;
      (let* ((n (- (interval-upper-bound (array-domain w) 0) 1))
             (n+1 (fx+ n 1))
             (indices (make-vector n+1)))
        ;; The first entry of ‘indices’ is ignore. Do not bother to set
        ;; it. Set the others to 1, 2, 3, ... , n.
        (do-ec (:range j 1 n+1)
          (vector-set! indices j j))
        (vector-stable-sort! (lambda (i j)
                               (let ((i^ (vector-ref indices i))
                                     (j^ (vector-ref indices j)))
                                 (< (array-ref w j^) (array-ref w i^))))
                             indices 1)
        (values (make-array (array-domain w)
                            (lambda (j)
                              (let ((j^ (vector-ref indices j)))
                                (array-ref w j^))))
                (and U (make-array (array-domain U)
                                   (lambda (i j)
                                     (let ((j^ (vector-ref indices j)))
                                       (array-ref U i j^)))))
                (and V (make-array (array-domain V)
                                   (lambda (i j)
                                     (let ((j^ (vector-ref indices j)))
                                       (array-ref V i j^))))))))

    (define (svd A with-U? with-V?)
      ;;
      ;; Compute the singular value decomposition (SVD) of the real
      ;; matrix stored in SRFI-179 array A. A is not altered.
      ;;
      ;; The indexing base of A may be 0, 1, some other number, or
      ;; different for the two dimensions. However, all the output
      ;; arrays are 1-indexed, read-only SRFI-179 arrays.
      ;;
      ;; Our definition of the singular value decomposition of a real
      ;; matrix A is A = UΣVᵀ where A and U are m×n, Σ and V are n×n.
      ;;
      ;; UᵀU = VᵀV = VVᵀ = I, the n×n identity matrix.
      ;;
      ;; Σ is a diagonal matrix of the singular values (the
      ;; non-negative square roots of the eigenvalues of AᵀA). In
      ;; addition, U comprises orthonormalized eigenvectors associated
      ;; with the n largest eigenvalues of AAᵀ, and V comprises the
      ;; orthonormalized eigenvectors of AᵀA.
      ;;
      ;; Return values:
      ;;
      ;;   ierr : If the SVD was successfully computed, then ierr=0;
      ;;          otherwise ierr=k, where convergence failed on the
      ;;          kth singular value.
      ;;
      ;;   w : The diagonal of Σ. In other words, the singular values.
      ;;       The values will be sorted in descending order.
      ;;
      ;;   U : If with-U? is false, then U=#f. Otherwise, it is the
      ;;       matrix U.
      ;;
      ;;   V : If with-V? is false, then V=#f. Otherwise, it is the
      ;;       matrix V.
      ;;
      (let-values (((ierr w U V)
                    (svd-based-on-eispack A with-U? with-V?)))
        (if (zero? ierr)
            (let-values (((w U V) (sort-svd w U V)))
              (values ierr w U V))
            (values ierr w U V))))

    )) ;; end library.

(import (scheme base)
        (scheme write)
        (srfi 179)
        (srfi 42)
        (svd))

;; Common Lisp-style formatting.
(import (format))

(define m (read))
(define n (read))

(define A
  (make-specialized-array
   (make-interval #(1 1) (vector (+ m 1) (+ n 1)))
   f64-storage-class))

;; Read the elements of the input array. They are assumed to be in
;; row-major order.
(do-ec (nested (:range i 1 (+ m 1))
               (:range j 1 (+ n 1)))
  (array-set! A (inexact (read)) i j))

(define-values (ierr w U V) (svd A #t #t))

(format #t "U:~%")
(do-ec (:range i 1 (+ m 1))
  (begin
    (do-ec (:range j 1 (+ n 1))
      (format #t "~30,14F" (array-ref U i j)))
    (format #t "~%")))

(format #t "~%")

(format #t "Σ:~%")
(do-ec (:range i 1 (+ n 1))
  (begin
    (do-ec (:range j 1 (+ n 1))
      (format #t "~30,14F" (if (= j i) (array-ref w i) 0.0)))
    (format #t "~%")))

(format #t "~%")

(format #t "V:~%")
(do-ec (:range i 1 (+ n 1))
  (begin
    (do-ec (:range j 1 (+ n 1))
      (format #t "~30,14F" (array-ref V i j)))
    (format #t "~%")))
