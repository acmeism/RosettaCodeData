#lang racket/base
(module sha256 racket/base
  ;; define a quick SH256 FFI interface, similar to the Racket's default
  ;; SHA1 interface (from [[SHA-256#Racket]])
  (provide sha256)
  (require ffi/unsafe ffi/unsafe/define openssl/libcrypto)
  (define-ffi-definer defcrypto libcrypto)
  (defcrypto SHA256_Init   (_fun _pointer -> _int))
  (defcrypto SHA256_Update (_fun _pointer _pointer _long -> _int))
  (defcrypto SHA256_Final  (_fun _pointer _pointer -> _int))
  (define (sha256 bytes)
    (define ctx (malloc 128))
    (define result (make-bytes 32))
    (SHA256_Init ctx)
    (SHA256_Update ctx bytes (bytes-length bytes))
    (SHA256_Final result ctx)
    ;; (bytes->hex-string result) -- not needed, we want bytes
    result))

(require
  ;; On windows I needed to "raco planet install soegaard digetst.plt 1 2"
  (only-in (planet soegaard/digest:1:2/digest) ripemd160-bytes)
  (submod "." sha256))

;; Quick utility
(define << arithmetic-shift) ; a bit shorter

;; From: https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
;; Using Bitcoin's stage numbers:

;; 1 - Take the corresponding public key generated with it
;; (65 bytes, 1 byte 0x04, 32 bytes corresponding to X coordinate,
;;  32 bytes corresponding to Y coordinate)
(define (stage-1 X Y)
  (define (integer->bytes! i B)
    (define l (bytes-length B))
    (for ((b (in-range 0 l))) (bytes-set! B (- l b 1) (bitwise-bit-field i (* b 8) (* (+ b 1) 8)))) B)
  (integer->bytes! (+ (<< 4 (* 32 8 2)) (<< X (* 32 8)) Y) (make-bytes 65)))

;; 2 - Perform SHA-256 hashing on the public key
(define stage-2 sha256)

;; 3 - Perform RIPEMD-160 hashing on the result of SHA-256
(define stage-3 ripemd160-bytes)

;; 4 - Add version byte in front of RIPEMD-160 hash (0x00 for Main Network)
(define (stage-4 s3)
  (bytes-append #"\0" s3))

;; 5 - Perform SHA-256 hash on the extended RIPEMD-160 result
;; 6 - Perform SHA-256 hash on the result of the previous SHA-256 hash
(define (stage-5+6 s4)
  (values s4 (sha256 (sha256 s4))))

;; 7 - Take the first 4 bytes of the second SHA-256 hash. This is the address checksum
(define (stage-7 s4 s6)
  (values s4 (subbytes s6 0 4)))

;; 8 - Add the 4 checksum bytes from stage 7 at the end of extended RIPEMD-160 hash from stage 4.
;;     This is the 25-byte binary Bitcoin Address.
(define (stage-8 s4 s7)
  (bytes-append s4 s7))

;; 9 - Convert the result from a byte string into a base58 string using Base58Check encoding.
;;     This is the most commonly used Bitcoin Address format
(define stage-9 (base58-encode 33))

(define ((base58-encode l) B)
  (define b58 #"123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")
  (define rv (make-bytes l (char->integer #\1))) ; already padded out with 1's
  (define b-int (for/fold ((i 0)) ((b (in-bytes B))) (+ (<< i 8) b)))
  (let loop ((b b-int) (l l))
    (if (zero? b) rv
        (let-values (((q r) (quotient/remainder b 58)))
          (define l- (- l 1))
          (bytes-set! rv l- (bytes-ref b58 r))
          (loop q l-)))))

;; Takes two (rather large) ints for X and Y, returns base-58 PAP.
(define public-address-point
  (compose stage-9 stage-8 stage-7 stage-5+6 stage-4 stage-3 stage-2 stage-1))

(public-address-point
 #x50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352
 #x2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(module+ test
  (require tests/eli-tester (only-in openssl/sha1 bytes->hex-string))
  (define bytes->HEX-STRING (compose string-upcase bytes->hex-string))
  (test
   ((base58-encode 33)
    (bytes-append #"\x00\x01\x09\x66\x77\x60\x06\x95\x3D\x55\x67\x43"
                  #"\x9E\x5E\x39\xF8\x6A\x0D\x27\x3B\xEE\xD6\x19\x67\xF6"))
   =>
   #"16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM")

  (define-values (test-X test-Y)
    (values #x50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352
            #x2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6))
  (define s1 (stage-1 test-X test-Y))
  (define s2 (stage-2 s1))
  (define s3 (stage-3 s2))
  (define s4 (stage-4 s3))
  (define-values (s4_1 s6) (stage-5+6 s4))
  (define-values (s4_2 s7) (stage-7 s4 s6))
  (define s8 (stage-8 s4 s7))
  (define s9 (stage-9 s8))

  (test
   (bytes->HEX-STRING s1)
   => (string-append "0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453"
                     "A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6")
   (bytes->HEX-STRING s2) => "600FFE422B4E00731A59557A5CCA46CC183944191006324A447BDB2D98D4B408"
   (bytes->HEX-STRING s3) => "010966776006953D5567439E5E39F86A0D273BEE"
   (bytes->HEX-STRING s4) => "00010966776006953D5567439E5E39F86A0D273BEE"
   (bytes->HEX-STRING s6) => "D61967F63C7DD183914A4AE452C9F6AD5D462CE3D277798075B107615C1A8A30"
   (bytes->HEX-STRING s7) => "D61967F6"
   (bytes->HEX-STRING s8) => "00010966776006953D5567439E5E39F86A0D273BEED61967F6"
   s9 => #"16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM"))
