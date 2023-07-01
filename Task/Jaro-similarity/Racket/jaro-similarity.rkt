#lang racket/base
;; {{trans|C}}
(require data/bit-vector)

(define (jaro-distance str1 str2)
  (define str1-len (string-length str1))
  (define str2-len (string-length str2))
  (cond
    [(and (zero? str1-len) (zero? str2-len)) 0]
    [(or  (zero? str1-len) (zero? str2-len)) 1]
    [else
     ;; vectors of bools that signify if that char in the matching string has a match
     (define str1-matches (make-bit-vector str1-len))
     (define str2-matches (make-bit-vector str2-len))
     (define matches
       ;; max distance between two chars to be considered matching
       (let ((match-distance (sub1 (quotient (max str1-len str2-len) 2))))
         (for/fold ((matches 0))
                   ((i (in-range 0 str1-len))
                    (c1 (in-string str1)))
           (define start (max 0 (- i match-distance)))
           (define end (min (+ i match-distance 1) str2-len))
           (for/fold ((matches matches))
                     ((k (in-range start end))
                      (c2 (in-string str2 start))
                      #:unless (bit-vector-ref str2-matches k) ; if str2 already has a match continue
                      #:when (char=? c1 c2) ; if str1 and str2 are not
                      #:final #t)
             ;; otherwise assume there is a match
             (bit-vector-set! str1-matches i #t)
             (bit-vector-set! str2-matches k #t)
             (add1 matches)))))
     (cond
       [(zero? matches) 0]
       [else
        (define-values (transpositions*2 k+)
          (for/fold ((transpositions 0) (k 0))
                    ((i (in-range 0 str1-len))
                     (c1 (in-string str1))
                     (b1 (in-bit-vector str1-matches))
                     ;; if there are no matches in str1 continue
                     #:when b1)
            (define k+ (for/first ((k+ (in-range k str2-len))
                                   (b2 (in-bit-vector str2-matches k))
                                   #:when b2)
                         k+))
            (values
             (+ transpositions (if (char=? c1 (string-ref str2 k+)) 0 1)) ; increment transpositions
             (add1 k+)))) ;; while there is no match in str2 increment k

        ;; divide the number of transpositions by two as per the algorithm specs
        ;; this division is valid because the counted transpositions include both
        ;; instances of the transposed characters.
        (define transpositions (quotient transpositions*2 2))

        ;; return the Jaro distance
        (/ (+ (/ matches str1-len)
              (/ matches str2-len)
              (/ (- matches transpositions) matches))
           3)])]))

(module+ test
  (jaro-distance "MARTHA"    "MARHTA"); 0.944444
  (exact->inexact (jaro-distance "MARTHA"    "MARHTA")); 0.944444
  (jaro-distance "DIXON"     "DICKSONX"); 0.766667
  (exact->inexact (jaro-distance "DIXON"     "DICKSONX")); 0.766667
  (jaro-distance "JELLYFISH" "SMELLYFISH"); 0.896296
  (exact->inexact (jaro-distance "JELLYFISH" "SMELLYFISH"))); 0.896296
