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

(define text* (for/vector ([c (regexp-replace* #px"\\s+" text "")])
                (- (char->integer c) first-char)))
(define N (vector-length text*))

(define (col-guesses len)
  (for/list ([ofs len])
    (define text (for/list ([i (in-range ofs N len)]) (vector-ref text* i)))
    (define cN (length text))
    (define cfreqs (make-vector chars# 0))
    (for ([c (in-list text)])
      (vector-set! cfreqs c (add1 (vector-ref cfreqs c))))
    (for ([i chars#]) (vector-set! cfreqs i (/ (vector-ref cfreqs i) cN)))
    (argmin car
      (for/list ([d chars#])
        (cons (for/sum ([i chars#])
                (expt (- (vector-ref freqs i)
                         (vector-ref cfreqs (modulo (+ i d) chars#)))
                      2))
              d)))))

(define best-key
  (cdr (argmin car
         (for/list ([len (range 1 (add1 max-keylen))])
           (define guesses (col-guesses len))
           (cons (/ (apply + (map car guesses)) len) (map cdr guesses))))))

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
