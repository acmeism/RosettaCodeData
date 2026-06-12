#lang racket
(require (only-in web-server/stuffers/hmac-sha1 HMAC-SHA1))

(define << arithmetic-shift) ; deep down, there lurks a C programmer in me
(define && bitwise-and)

;; These are the parameters available through RFC6238
(define T0 (make-parameter current-seconds)) ; produces unix epoch times. parameterised for testing
(define X  (make-parameter 30))
(define H  (make-parameter (lambda (k d) (HMAC-SHA1 k d))))
(define N  (make-parameter 6))

;; http://tools.ietf.org/html/rfc4226#section-5.3
(define (HOTP sha1-bytes (Digit (N)))
  (define (DT b)
    (define offset (&& #b1111 (bytes-ref b 19)))
    (define P/32 (subbytes b offset (+ offset 4)))
    (+ (<< (bytes-ref P/32 3) 0) (<< (bytes-ref P/32 2) 8) (<< (bytes-ref P/32 1) 16)
       (<< (&& #b01111111 (bytes-ref P/32 0)) 24)))
  (define s-bits (DT sha1-bytes))
  (modulo s-bits (expt 10 Digit)))

(define (Generate-HOTP K C (Digit (N)))
  (HOTP ((H) K (integer->integer-bytes C 8 #t)) Digit))

;; http://tools.ietf.org/html/rfc6238
(define (T #:previous-timeframe (T- 0))
  (- (quotient ((T0)) (X)) T-))

(define (TOTP K #:previous-timeframe (T- 0)) (Generate-HOTP K (T #:previous-timeframe T-) (N)))

;; RFC 3548
(define (pad-needed bits)
  (modulo (- 5 bits) 5))

(define (5-bits->base32-char n)
  (string-ref "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567" n))

(define (base32-encode-block bs)
  (define v (for/fold ((v 0)) ((b bs)) (+ (<< v 8) b)))
  (define v-bits (* 8 (bytes-length bs)))
  (define pad (pad-needed v-bits))
  (define padded-bits (+ v-bits pad))
  (define v-padded (<< v pad))
  (for ((end-bit (in-range padded-bits 4 -5)))
    (write-char (5-bits->base32-char (bitwise-bit-field v-padded (- end-bit 5) end-bit))))
  (write-string (make-string (- 8 (/ padded-bits 5)) #\=)))

(define A-char (char->integer #\A))
(define Z-char (char->integer #\Z))
(define 2-char (char->integer #\2))
(define 7-char (char->integer #\7))
(define =-char (char->integer #\=))
(define (byte->5bit b)
  (cond
    [(<= A-char b Z-char) (- b A-char)]
    [(<= 2-char b 7-char) (+ 26 (- b 2-char))]
    [else #f]))

(define (base32-decode-block bs)
  (for*/fold ((v 0) (b 0)) ((bt bs) (b5 (in-value (byte->5bit bt))) #:break (not b5))
    (define v+ (+ (<< v 5) b5))
    (define b+ (+ b 5))
    (cond
      [(< b+ 8) (values v+ b+)]
      [else
       (define start-bit (- b+ 8))
       (write-byte (&& 255 (<< v+ (- start-bit))))
       (values (bitwise-bit-field v+ 0 start-bit) start-bit)])))

(define (base32-encode) (for ((bs (in-port (curry read-bytes 5)))) (base32-encode-block bs)))
(define (base32-decode) (for ((bs (in-port (curry read-bytes 8)))) (base32-decode-block bs)))

(define (base32-encode-bytes b) (with-input-from-bytes b (λ () (with-output-to-bytes base32-encode))))
(define (base32-decode-bytes b) (with-input-from-bytes b (λ () (with-output-to-bytes base32-decode))))

(module+ main
  (require racket/date)
  ;; my secret, as stuck on a postit note on my monitor
  (define Tims-K #"Super Secret Password Key 88!")

  (define ((pseudo-time-now (offset 0))) (+ 1413976828 offset))
  (define totp #f)
  (parameterize ((T0 (pseudo-time-now)))
    (printf "I want authentication at: ~a ~s~%" ((T0)) (date->string (seconds->date ((T0))) #t))
    (set! totp (TOTP (base32-encode-bytes Tims-K)))
    (printf "My TOTP is: ~a~%" totp)
    (printf "sent to authentication service...~%"))

  ;; as stored on authenticator
  (define K/base32 (base32-encode-bytes Tims-K))
  (printf "K/base32: ~a~%" K/base32)

  (parameterize ((T0 (pseudo-time-now 1)))
    (printf "1 second later... authentication service checks against: ~a~%" totp)
    (define auth-totp (TOTP K/base32))
    (printf "~a is the same? ~a~%" auth-totp (= totp auth-totp)))

  (parameterize ((T0 (pseudo-time-now 3)))
    (printf "but 3 seconds later... authentication service checks against: ~a~%" totp)
    (define auth-totp (TOTP K/base32))
    (printf "~a is the same? ~a~%" auth-totp (= totp auth-totp))
    (printf "oh dear... fall back one time-frame...~%")
    (define auth-totp-1 (TOTP K/base32 #:previous-timeframe 1))
    (printf "~a is *that* the same? ~a~%" auth-totp-1 (= totp auth-totp-1))))

(module+ test
  (require tests/eli-tester)
  (test
   ;; From RFC4226 Page 7
   (HOTP (bytes
          #x1f #x86 #x98 #x69 #x0e #x02 #xca #x16 #x61 #x85
          #x50 #xef #x7f #x19 #xda #x8e #x94 #x5b #x55 #x5a)
         6)
   => 872921

   (pad-needed 0) => 0
   (pad-needed 2) => 3
   (pad-needed 4) => 1
   (pad-needed 6) => 4
   (pad-needed 8) => 2
   (pad-needed 10) => 0
   (pad-needed 12) => 3

   ;; http://commons.apache.org/proper/commons-codec/xref-test/org/apache/commons/codec/binary/Base32Test.html
   (base32-encode-bytes #"")       => #""
   (base32-encode-bytes #"f")      => #"MY======"
   (base32-encode-bytes #"fo")     => #"MZXQ===="
   (base32-encode-bytes #"foo")    => #"MZXW6==="
   (base32-encode-bytes #"foob")   => #"MZXW6YQ="
   (base32-encode-bytes #"fooba")  => #"MZXW6YTB"
   (base32-encode-bytes #"foobar") => #"MZXW6YTBOI======"

   (base32-decode-bytes #"")                 => #""
   (base32-decode-bytes #"MY======")         => #"f"
   (base32-decode-bytes #"MZXQ====")         => #"fo"
   (base32-decode-bytes #"MZXW6===")         => #"foo"
   (base32-decode-bytes #"MZXW6YQ=")         => #"foob"
   (base32-decode-bytes #"MZXW6YTB")         => #"fooba"
   (base32-decode-bytes #"MZXW6YTBOI======") => #"foobar"

   (base32-encode-bytes #"Super Secret Password Key 88!")
   => #"KN2XAZLSEBJWKY3SMV2CAUDBONZXO33SMQQEWZLZEA4DQII="
   ))
