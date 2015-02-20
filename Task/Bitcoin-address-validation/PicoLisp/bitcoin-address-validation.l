(setq *Alphabet
   (chop "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"))

# if returns NIL then adress is already invalid
(de base58 (Str)
   (let N 0
      (for L (chop Str)
         (setq N
            (+
               (* N 58)
               (index L *Alphabet)
               -1 ) ) )

      N )
)

(de sha256 (Lst)
   (native "libcrypto.so" "SHA256"
      '(B . 32)
      (cons
         NIL
         (32)
         (native "libcrypto.so" "SHA256" '(B . 32)
            (cons NIL (32) Lst) (length Lst) '(NIL (32))) )
      32
      '(NIL (32)) ) )

(de bytes25 (N)
   (flip
      (make
         (do 25
            (link (% N 256))
            (setq N (/ N 256)) ) ) ) )

(de valid (Str)
   (and
      (base58 Str)
      (bytes25 @)
      (=
         (head 4 (sha256 (head 21 @)))
         (tail 4 @) ) ) )

(bye)
