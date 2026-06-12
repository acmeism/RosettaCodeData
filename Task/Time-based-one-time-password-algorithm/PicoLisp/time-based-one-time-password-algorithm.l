(load "sha1.l")

(de hmac ("Fun" Msg Key)
   (let (Key (copy Key)  Len (length Key))
      (and
         (> Len 64)
         (setq Key ("Fun" Key)) )
      (setq Key (need -64 Key 0))
      ("Fun"
         (append
            (mapcar x| (need 64 `(hex "5C")) Key)
            ("Fun" (append (mapcar x| (need 64 `(hex "36")) Key) Msg)) ) ) ) )

(de endian64 (N)
   (make
      (do 8
         (yoke (& N 255))
         (setq N (>> 8 N)) ) ) )

(de endian32 (L)
   (apply
      |
      (mapcar >> (-24 -16 -8 0) L) ) )

(de truncate (Lst D)
   (let L (nth Lst (inc (& (last Lst) `(hex "F"))))
      (set L (& (car L) `(hex "7F")))
      (% (endian32 (head 4 L)) (** 10 D)) ) )

(de hotp (K N D)
   (default D 6)
   (truncate
      (hmac 'sha1 (endian64 N) K)
      D ) )

(def 'totp hotp)

# RFC4226
(for
   (I . N)
   (755224 287082 359152 969429 338314
      254676 287922 162583 399871 520489 )
   (test
      N
      (hotp (mapcar char (chop "12345678901234567890")) (dec I)) ) )

# RFC6238
(for L
   (quote
      (1 . 94287082) (37037036 . 7081804) (37037037 . 14050471)
      (41152263 . 89005924) (66666666 . 69279037) (666666666 . 65353130) )
   (test
      (cdr L)
      (totp (mapcar char (chop "12345678901234567890")) (car L) 8) ) )
