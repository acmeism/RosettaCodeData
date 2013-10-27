#lang at-exp racket

(define max-keylen 30)

(define text
  @~a{MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH
      VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD
      ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS
      FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG
      ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ
      ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS
      JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT
      LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST
      MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH
      QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV
      RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW
      TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO
      SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR
      ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX
      BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB
      BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA
      FWAML ZZRXJ EKAHV FASMU LVVUT TGK})

(define first-char (char->integer #\A))
(define chars# (- (char->integer #\Z) first-char -1))

(define freqs ; english letter frequencies from wikipedia
  ((compose1 list->vector (curry map (curryr / 100000.0)))
   '(8167 1492 2782 4253 12702 2228 2015 6094 6966 153 772 4025 2406
     6749 7507 1929 95 5987 6327 9056 2758 978 2360 150 1974 74)))

(define (n*n-1 n) (* n (sub1 n)))

(define text* (for/vector ([c (regexp-replace* #px"\\s+" text "")])
                (- (char->integer c) first-char)))
(define N (vector-length text*))
(define (get-col-length+freqs width offset)
  (define text (for/list ([i (in-range offset N width)]) (vector-ref text* i)))
  (define cN (length text))
  (define freqs (make-vector chars# 0))
  (for ([c (in-list text)]) (vector-set! freqs c (add1 (vector-ref freqs c))))
  (values cN freqs))

(define expected-IC (* chars# (for*/sum ([x freqs]) (* x x))))

;; maps key lengths to average index of coincidence
(define keylen->ICs
  (for/vector ([len (in-range 1 (add1 (* max-keylen 2)))])
    (for/sum ([ofs len])
      (define-values [cN cfreqs] (get-col-length+freqs len ofs))
      (/ (for/sum ([i chars#]) (n*n-1 (vector-ref cfreqs i)))
         (/ (n*n-1 cN) chars#) len 1.0))))

;; given a key length find the key that minimizes errors from alphabet freqs,
;; return (cons average-error key)
(define (guess-key len)
  (define guesses
    (for/list ([ofs len])
      (define-values [cN cfreqs] (get-col-length+freqs len ofs))
      (for ([i chars#]) (vector-set! cfreqs i (/ (vector-ref cfreqs i) cN)))
      (argmin car
        (for/list ([d chars#])
          (cons (for/sum ([i chars#])
                  (expt (- (vector-ref freqs i)
                           (vector-ref cfreqs (modulo (+ i d) chars#)))
                        2))
                d)))))
  (cons (/ (apply + (map car guesses)) len) (map cdr guesses)))

;; look for a key length that minimizes error from expected-IC, with some
;; stupid consideration of multiples of the length (which should also have low
;; errors), for each one guess a key, then find the one that minimizes both (in
;; a way that looks like it works, but undoubtedly is wrong in all kinds of
;; ways) and return the winner key
(define best-key
  ((compose1 cdr (curry argmin car))
   (for/list ([i (* max-keylen 2)])
     ;; get the error from the expected-IC for the length and its multiples,
     ;; with decreasing weights for the multiples
     (define with-multiples
       (for/list ([j (in-range i (* max-keylen 2) (add1 i))] [div N])
         (cons (/ (abs (- (vector-ref keylen->ICs j) expected-IC)) expected-IC)
               (/ (add1 div)))))
     (define total (/ (for/sum ([x with-multiples]) (* (car x) (cdr x)))
                      (for/sum ([x with-multiples]) (cdr x))))
     (define guess (guess-key (add1 i)))
     (define guess*total (* total (car guess) (car guess)))
     ;; (printf "~a~a: ~a ~s\n" (if (< i 9) " " "") (add1 i)
     ;;       (list total (car guess) guess*total) (cdr guess))
     (cons guess*total (cdr guess)))))

(printf "Best key found: ")
(for ([c best-key]) (display (integer->char (+ c first-char))))
(newline)

(printf "Decoded text:\n")
(define decode-num
  (let ([cur '()])
    (λ(n) (when (null? cur) (set! cur best-key))
          (begin0 (modulo (- n (car cur)) chars#) (set! cur (cdr cur))))))
(for ([c text])
  (define n (- (char->integer c) first-char))
  (if (not (< -1 n chars#)) (display c)
      (display (integer->char (+ first-char (decode-num n))))))
(newline)
