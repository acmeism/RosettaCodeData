#lang racket
(require math/number-theory)
(define-logger rsa)
(current-logger rsa-logger)

;; -| STRING TO NUMBER MAPPING |----------------------------------------------------------------------
(define (bytes->number B) ; We'll need our data in numerical form ..
  (for/fold ((rv 0)) ((b B)) (+ b (* rv 256))))

(define (number->bytes N) ; .. and back again
  (define (inr n b) (if (zero? n) b (inr (quotient n 256) (bytes-append (bytes (modulo n 256)) b))))
  (inr N (bytes)))

;; -| RSA PUBLIC / PRIVATE FUNCTIONS |----------------------------------------------------------------
;; The basic definitions... pretty well lifted from the text book!
(define ((C e n) p)
  ;; Just do the arithmetic to demonstrate RSA...
  ;; breaking large messages into blocks is something for another day.
  (unless (< p n) (raise-argument-error 'C (format "(and/c integer? (</c ~a))" n) p))
  (modular-expt p e n))

(define ((P d n) c)
  (modular-expt c d n))

;; -| RSA KEY GENERATION |----------------------------------------------------------------------------
;; Key generation
;; Full description of the steps can be found on Wikipedia
(define (RSA-keyset function-base-name)
  (log-info "RSA-keyset: ~s" function-base-name)
  (define max-k 4294967087)
  ;; I'm guessing this RNG is about as cryptographically strong as replacing spaces with tabs.
  (define (big-random n-rolls)
    (for/fold ((rv 1)) ((roll (in-range n-rolls 0 -1))) (+ (* rv (add1 max-k)) 1 (random max-k))))
  (define (big-random-prime)
    (define start-number (big-random (/ 1024 32)))
    (log-debug "got large (possibly non-prime) number, finding next prime")
    (next-prime (match start-number ((? odd? o) o) ((app add1 e) e))))

  ;; [1] Choose two distinct prime numbers p and q.
  (log-debug "generating p")
  (define p (big-random-prime))
  (log-debug "p generated")
  (log-debug "generating q")
  (define q (big-random-prime))
  (log-debug "q generated")
  (log-info "primes generated")

  ;; [2] Compute n = pq.
  (define n (* p q))

  ;; [3] Compute φ(n) = φ(p)φ(q) = (p − 1)(q − 1) = n - (p + q -1),
  ;;                    where φ is Euler's totient function.
  (define φ (- n (+ p q -1)))

  ;; [4] Choose an integer e such that 1 < e < φ(n) and gcd(e, φ(n)) = 1; i.e., e and φ(n) are
  ;;     coprime. ... most commonly 2^16 + 1 = 65,537 ...
  (define e (+ (expt 2 16) 1))

  ;; [5] Determine d as d ≡ e−1 (mod φ(n)); i.e., d is the multiplicative inverse of e (modulo φ(n)).
  (log-debug "generating d")
  (define d (modular-inverse e φ))
  (log-info "d generated")
  (values n e d))

;; -| GIVE A USABLE SET OF PRIVATE STUFF TO A USER |--------------------------------------------------
;; six values: the public (encrypt) function (numeric)
;;             the private (decrypt) function (numeric)
;;             the public (encrypt) function (bytes)
;;             the private (decrypt) function (bytes)
;;             private (list n e d)
;;             public (list n e)
(define (RSA-key-pack #:function-base-name function-base-name)
  (define (rnm-fn f s) (procedure-rename f (string->symbol (format "~a-~a" function-base-name s))))
  (define-values (n e d) (RSA-keyset function-base-name))
  (define my-C (rnm-fn (C e n) "C"))
  (define my-P (rnm-fn (P d n) "P"))
  (define my-encrypt (rnm-fn (compose number->bytes my-C bytes->number) "encrypt"))
  (define my-decrypt (rnm-fn (compose number->bytes my-P bytes->number) "decrypt"))
  (values my-C my-P my-encrypt my-decrypt (list n e d) (list n e)))

;; -| HEREON IS JUST A LOAD OF CHATTY DEMOS |---------------------------------------------------------
(define (narrated-encrypt-bytes C who plain-text)
  (define plain-n (bytes->number plain-text))
  (define cypher-n (C plain-n))
  (define cypher-text (number->bytes cypher-n))
  (printf #<<EOS
~a wants to send plain text: ~s
  as number: ~s
  cyphered number: ~s
sent by ~a over the public interwebs:
~s
...


EOS
          who plain-text plain-n cypher-n who cypher-text)
  cypher-text)

(define (narrated-decrypt-bytes P who cypher-text)
  (define cypher-n (bytes->number cypher-text))
  (define plain-n (P cypher-n))
  (define plain-text (number->bytes plain-n))
  (printf #<<EOS
...
~s
  received by ~a
  as number: ~s
  decyphered (with P) number: ~s
decyphered text:
~s


EOS
          cypher-text who cypher-n plain-n plain-text)
  plain-text)

;; ENCRYPT AND DECRYPT A MESSAGE WITH THE e.g. KEYS
(define-values (given-n given-e given-d)
  (values 9516311845790656153499716760847001433441357
          65537
          5617843187844953170308463622230283376298685))

;; Get the keys specific RSA functions
(for ((message-text (list #"hello world" #"TOP SECRET!")))
  (define Bobs-public-function (C given-e given-n))
  (define Bobs-private-function (P given-d given-n))
  (define cypher-text (narrated-encrypt-bytes Bobs-public-function "Alice" message-text))
  (define plain-text (narrated-decrypt-bytes Bobs-private-function "Bob" cypher-text))
  plain-text)

;; Demonstrate with larger keys.
;; (And include a free recap on digital signatures, too)
(define-values (A-pub-C A-pvt-P A-pub-encrypt A-pvt-decrypt A-pvt-keys A-pub-keys)
  (RSA-key-pack #:function-base-name 'Alice))
(define-values (B-pub-C B-pvt-P B-pub-encrypt B-pvt-decrypt B-pvt-keys B-pub-keys)
  (RSA-key-pack #:function-base-name 'Bob))

;; Since p and q are random, it is possible that message' = "message modulo {A,B}-key-n" will be too
;; big for "message' modulo {B,A}-key-n", if that happens then I run the program again until it
;; works. Strictly, we need blocking of the signed message -- which is not yet implemented.
(let* ((plain-A-to-B #"Dear Bob, meet you in Lymm at 1200, Alice")
       (signed-A-to-B         (A-pvt-decrypt plain-A-to-B))
       (unsigned-A-to-B       (A-pub-encrypt signed-A-to-B))
       (crypt-signed-A-to-B   (B-pub-encrypt signed-A-to-B))
       (decrypt-signed-A-to-B (B-pvt-decrypt crypt-signed-A-to-B))
       (decrypt-verified-B    (A-pub-encrypt decrypt-signed-A-to-B)))
  (printf
   #<<EOS
Alice wants to send ~s to Bob.
She "encrypts" with her private "decryption" key.
(A-prv msg) -> ~s
Only she could have done this (only she has the her private key data) -- so this is a signature on the
message. Anyone can verify the signature by "decrypting" the message with the public "encryption" key.
(A-pub (A-prv msg)) -> ~s
But anyone is able to do this, so there is no privacy here.
Everyone knows that it can only be Alice at Lymm at noon, but this message is for Bob's eyes only.
We need to encrypt this with his public key:
(B-pub (A-prv msg)) -> ~s
Which is what gets posted to alt.chat.secret-rendezvous
Bob decrypts this to get the signed message from Alice:
(B-prv (B-pub (A-prv msg))) -> ~s
And verifies Alice's signature:
(A-pub (B-prv (B-pub (A-prv msg)))) -> ~s
Alice genuinely sent the message.
And nobody else (on a.c.s-r, at least) has read it.

KEYS:
 Alice's full set: ~s
 Bob's full set: ~s
EOS
   plain-A-to-B signed-A-to-B unsigned-A-to-B crypt-signed-A-to-B decrypt-signed-A-to-B
   decrypt-verified-B A-pvt-keys B-pvt-keys))
