#lang racket/base
(require racket/string racket/match)
(define (str-rplc-at str replacement start (end (string-length str)))
  (string-append (substring str 0 start) replacement (substring str end)))

(define (split-on-commas s) (string-split s "," #:trim? #f))

(define (str-rplc-at* fxt pos . more)
  (match more
    [(list (app split-on-commas froms) (app split-on-commas tos) even-more ...)
     (define txt-maybe
       (for/first ((f froms) (t tos) #:when (string-prefix? (substring fxt pos) f))
         (str-rplc-at fxt t pos (+ pos (string-length f)))))
     (apply str-rplc-at* (or txt-maybe fxt) pos even-more)]
    [_ fxt]))

(define (str-rplc-end* txf . more)
  (match more
    [(list (app split-on-commas froms) (app split-on-commas tos) even-more ...)
     (define txt-maybe
       (for/first ((f froms) (t tos) #:when (string-suffix? txf f))
         (str-rplc-at txf t (- (string-length txf) (string-length f)))))
     (apply str-rplc-end* (or txt-maybe txf) even-more)]
    [_ txf]))

(define vowels '("A" "E" "I" "O" "U"))
(define (vowel? s) (member s vowels))

;; ---------------------------------------------------------------------------------------------------
(define (normalise n) (regexp-replace* #px"\\W" (string-upcase n) ""))

(define (r:1 n) (str-rplc-at* n 0 "MAC,KN,K,PH,PF,SCH" "MCC,N,C,FF,FF,SSS"))

(define (r:2 n) (str-rplc-end* n "EE,IE,DT,RT,RD,NT,ND" "Y,Y,D,D,D,D,D"))

(define (r:3/4 in)
  (define (loop-4 name-4.1 key-3 i)
    (cond
      [(< i (string-length name-4.1))
       (define name-4.2/3/4
         (str-rplc-at* name-4.1 i "EV,A,E,I,O,U" "AF,A,A,A,A,A" #|4.1|# "Q,Z,M" "G,S,N" #|4.2|#
                       "KN,K" "N,C" #|4.3|# "SCH,PH" "SSS,FF" #|4.4|#))
       (define name-4.5/6
         (match-let ([(or (regexp "^(.)(.)(.)" (list n_1 n n1_))
                          (regexp "^(.)(.)" (list (app (λ _ "") n1_) n_1 n)))
                      (substring name-4.1 (sub1 i))])
           (match n
             ["H" #:when (or (not (vowel? n_1)) (not (vowel? n1_)))
                  (str-rplc-at name-4.2/3/4 n_1 i (add1 i))] ; 4.5
             ["W" #:when (vowel? n_1) (str-rplc-at name-4.2/3/4 "A" i (add1 i))] ; 4.6
             [_ name-4.2/3/4])))
       (define name-4.6_i (substring name-4.5/6 i (add1 i)))
       (define key-4.7 (if (string=? name-4.6_i (substring key-3 (sub1 (string-length key-3))))
                           key-3 (string-append key-3 name-4.6_i)))
       (loop-4 name-4.5/6 key-4.7 (add1 i))]
      [else key-3]))
  (loop-4 in (substring in 0 1) 1))

(define (r:5/6/7/8 n) (str-rplc-end* n "S,AY,A" ",Y,"))

(define r:9 (match-lambda [(regexp #px"^(.{6})(.+)" (list _ l r)) (format "~a[~a]" l r)] [n n]))

(define nysiis (apply compose (reverse (list normalise r:1 r:2 r:3/4 r:5/6/7/8 r:9))))

(module+ test
  (require rackunit)
  (define names
    (list "Bishop" "Carlson" "Carr" "Chapman" "Franklin" "Greene" "Harper" "Jacobs" "Larson"
          "Lawrence" "Lawson" "Louis, XVI" "Lynch" "Mackenzie" "Matthews" "McCormack" "McDaniel"
          "McDonald" "Mclaughlin" "Morrison" "O'Banion" "O'Brien" "Richards" "Silva" "Watkins"
          "Wheeler" "Willis" "brown, sr" "browne, III" "browne, IV" "knight" "mitchell" "o'daniel"))

  (define py-nysiis-names ; results from python (with [] added)
    (list "BASAP" "CARLSA[N]" "CAR" "CAPNAN" "FRANCL[AN]" "GRAN" "HARPAR" "JACAB" "LARSAN" "LARANC"
          "LASAN" "LASXV" "LYNC" "MCANSY" "MATA" "MCARNA[C]" "MCDANA[L]" "MCDANA[LD]" "MCLAGL[AN]"
          "MARASA[N]" "OBANAN" "OBRAN" "RACARD" "SALV" "WATCAN" "WALAR" "WALA" "BRANSR" "BRAN"
          "BRANAV" "NAGT" "MATCAL" "ODANAL"))

  (for ((n names) (p py-nysiis-names))
    (check-equal? (nysiis n) p (format "(nysiis ~s) = ~s" n p))))
