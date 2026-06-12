#lang racket

(define ((base-n-alphabet-encode alphabet) hash-string (in-base 16))
  (define out-base (string-length alphabet))
  (let reduce-hash ((h (string->number (if (and (= in-base 16) (string-prefix? hash-string "0x"))
                                           (substring hash-string 2)
                                           hash-string)
                                       in-base))
                    (acc (list)))
    (if (zero? h)
        (list->string acc)
        (let-values (((q r) (quotient/remainder h out-base)))
          (reduce-hash q (cons (string-ref alphabet r) acc))))))

(define base58-check-encode (base-n-alphabet-encode "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"))

(module+ main
  (base58-check-encode "25420294593250030202636073700053352635053786165627414518" 10)
  (map base58-check-encode (list "0x61"
                                 "0x626262"
                                 "0x636363"
                                 "0x73696d706c792061206c6f6e6720737472696e67"
                                 "0x516b6fcd0f"
                                 "0xbf4f89001e670274dd"
                                 "0x572e4794"
                                 "0xecac89cad93923c02321"
                                 "0x10c8511e")))
