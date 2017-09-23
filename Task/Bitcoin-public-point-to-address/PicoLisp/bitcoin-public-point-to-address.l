(load "ripemd160.l")
(load "sha256.l")

(setq *B58Alpha
   (chop "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz") )
(de hex2L (H)
   (make
      (for (L (chop H) L (cddr L))
         (link (hex (pack (car L) (cadr L)))) ) ) )
(de b58enc (Lst)
   (let
      (P 1
         Z 0
         A
         (sum
            '((X)
               (* X (swap 'P (>> -8 P))) )
            (reverse Lst) ) )
   (for L Lst
      (T (n0 L))
      (inc 'Z) )
   (pack
      (need Z "1")
      (make
         (while (gt0 A)
            (yoke
               (prog1
                  (get *B58Alpha (inc (% A 58)))
                  (setq A (/ A 58)) ) ) ) ) ) ) )
(de point2address (X Y)
   (let L (conc (cons 4) (hex2L X) (hex2L Y))
      (b58enc
         (and
            (conc (cons 0) (ripemd160 (sha256 L)))
            (conc @ (head 4 (sha256 (sha256 @)))) ) ) ) )
(println
   (point2address
      "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352"
      "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6" ) )
