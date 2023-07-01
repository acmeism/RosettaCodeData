#lang racket
(define (flip-row! pzzl r)
  (define N (integer-sqrt (bytes-length pzzl)))
  (for* ((c (in-range N)))
    (define idx (+ c (* N r)))
    (bytes-set! pzzl idx (- 1 (bytes-ref pzzl idx)))))

(define (flip-col! pzzl c)
  (define N (integer-sqrt (bytes-length pzzl)))
  (for* ((r (in-range N)))
    (define idx (+ c (* N r)))
    (bytes-set! pzzl idx (- 1 (bytes-ref pzzl idx)))))

(define (new-game N (flips 10))
  (define N2 (sqr N))
  (define targ (list->bytes (for/list ((_ N2)) (random 2))))
  (define strt (bytes-copy targ))
  (for ((_ flips))
    (case (random 2)
      ((0) (flip-col! strt (random N)))
      ((1) (flip-row! strt (random N)))))
  (if (equal? strt targ) (new-game N) (values targ strt)))

(define (show-games #:sep (pzl-sep " | ") . pzzls)
  (define N (integer-sqrt (bytes-length (first pzzls))))
  (define caption (string-join (for/list ((c (in-range N))) (~a (add1 c))) ""))
  (define ruler   (string-join (for/list ((c (in-range N))) "-") ""))

  (define ((pzzle-row r) p)
    (string-join (for/list ((c (in-range N))) (~a (bytes-ref p (+ c (* N r))))) ""))

  (displayln
   (string-join
    (list*
     (format "  ~a" (string-join (for/list ((_ pzzls)) caption) pzl-sep))
     (format "  ~a" (string-join (for/list ((_ pzzls)) ruler) pzl-sep))
     (for/list ((r (in-range N)) (R (in-naturals (char->integer #\a))))
       (format "~a ~a" (integer->char R) (string-join (map (pzzle-row r) pzzls) pzl-sep))))
    "\n")))

(define (play N)
  (define-values (end start) (new-game N))
  (define (turn n (show? #t))
    (cond
      [(equal? end start) (printf "you won on turn #~a~%" n)]
      [else
       (when show? ;; don't show after whitespace
         (printf "turn #~a~%" n)
         (show-games start end))
       (match (read-char)
         [(? eof-object?) (printf "sad to see you go :-(~%")]
         [(? char-whitespace?) (turn n #f)]
         [(? char-numeric? c)
          (define cnum (- (char->integer c) (char->integer #\1)))
          (cond [(< -1 cnum N)
                 (printf "flipping col ~a~%" (add1 cnum))
                 (flip-col! start cnum)
                 (turn (add1 n))]
                [else (printf "column number out of range ~a > ~a~%" (add1 cnum) N)
                      (turn n)])]
         [(? char-lower-case? c)
          (define rnum (- (char->integer c) (char->integer #\a)))
          (cond [(< -1 rnum N)
                 (printf "flipping row ~a~%" (add1 rnum))
                 (flip-row! start rnum)
                 (turn (add1 n))]
                [else (printf "row number out of range ~a > ~a~%" (add1 rnum) (sub1 N))
                      (turn n)])]
         [else (printf "unrecognised character in input: ~s~%" else)
               (turn n)])]))
  (turn 0))
