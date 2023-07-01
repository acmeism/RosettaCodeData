(de *R160-R1 . (1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
               8 5 14 2 11 7 16 4 13 1 10 6 3 15 12 9
               4 11 15 5 10 16 9 2 3 8 1 7 14 12 6 13
               2 10 12 11 1 9 13 5 14 4 8 16 15 6 7 3
               5 1 6 10 8 13 3 11 15 2 4 9 12 7 16 14 .))
(de *R160-R2 . (6 15 8 1 10 3 12 5 14 7 16 9 2 11 4 13
                7 12 4 8 1 14 6 11 15 16 9 13 5 10 2 3
                16 6 2 4 8 15 7 10 12 9 13 3 11 1 5 14
                9 7 5 2 4 12 16 1 6 13 3 14 10 8 11 15
                13 16 11 5 2 6 9 8 7 3 14 15 1 4 10 12 .))
(de *R160-S1 . (11 14 15 12 5 8 7 9 11 13 14 15 6 7 9 8
               7 6 8 13 11 9 7 15 7 12 15 9 11 7 13 12
               11 13 6 7 14 9 13 15 14 8 13 6 5 12 7 5
               11 12 14 15 14 15 9 8 9 14 5 6 8 6 5 12
               9 15 5 11 6 8 13 12 5 12 13 14 11 8 5 6 .))
(de *R160-S2 . (8 9 9 11 13 15 15 5 7 7 8 11 14 14 12 6
                9 13 15 7 12 8 9 11 7 7 12 7 6 15 13 11
                9 7 15 11 8 6 6 14 12 13 5 14 13 13 7 5
                15 5 8 11 14 14 6 14 6 9 12 9 12 5 15 8
                8 5 12 9 12 5 14 6 8 13 6 5 15 13 11 11 .))

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de not32 (N)
   (x| N `(hex "FFFFFFFF")) )

(de add32 @
   (mod32 (pass +)) )

(de leftRotate (X C)
   (| (mod32 (>> (- C) X)) (>> (- 32 C) X)) )

(de ripemd160 (Str)
   (let Len (length Str)
      (setq Str
         (conc
            (need
               (- 8 (* 64 (/ (+ Len 1 8 63) 64)))
               (conc
                  (mapcar char (chop Str))
                  (cons `(hex "80")) )
               0 )
            (make
               (setq Len (* 8 Len))
               (do 8
                  (link (& Len 255))
                  (setq Len (>> 8 Len )) ) ) ) ) )
   (let
      (H0 `(hex "67452301")
         H1 `(hex "EFCDAB89")
         H2 `(hex "98BADCFE")
         H3 `(hex "10325476")
         H4 `(hex "C3D2E1F0") )
      (while Str
         (let
            (A1 H0  B1 H1  C1 H2  D1 H3  E1 H4
               A2 H0  B2 H1  C2 H2  D2 H3  E2 H4
               W (make
                     (do 16
                        (link
                           (apply |
                              (mapcar >> (0 -8 -16 -24) (cut 4 'Str)) ) ) ) ) )
            (use (Func1 Func2 Hex1 Hex2)
               (for I 80
                  (cond
                     ((>= 16 I)
                        (setq
                           Func1 '(x| B1 C1 D1)
                           Func2 '(x| B2 (| C2 (not32 D2)))
                           Hex1 0
                           Hex2 `(hex "50A28BE6") ) )
                     ((>= 32 I)
                        (setq
                           Func1 '(| (& B1 C1) (& (not32 B1) D1))
                           Func2 '(| (& B2 D2) (& C2 (not32 D2)))
                           Hex1 `(hex "5A827999")
                           Hex2 `(hex "5C4DD124") ) )
                     ((>= 48 I)
                        (setq
                           Func1 '(x| (| B1 (not32 C1)) D1)
                           Func2 '(x| (| B2 (not32 C2)) D2)
                           Hex1 `(hex "6ED9EBA1")
                           Hex2 `(hex "6D703EF3") ) )
                     ((>= 64 I)
                        (setq
                           Func1 '(| (& B1 D1) (& C1 (not32 D1)))
                           Func2 '(| (& B2 C2) (& (not32 B2) D2))
                           Hex1 `(hex "8F1BBCDC")
                           Hex2 `(hex "7A6D76E9") ) )
                     (T
                        (setq
                           Func1 '(x| B1 (| C1 (not32 D1)))
                           Func2 '(x| B2 C2 D2)
                           Hex1 `(hex "A953FD4E")
                           Hex2 0 ) ) )
                  (setq
                     Tmp1
                     (add32
                        (leftRotate
                           (add32
                              A1
                              (eval Func1)
                              (get W (pop '*R160-R1))
                              Hex1 )
                           (pop '*R160-S1) )
                        E1 )
                     Tmp2
                     (add32
                        (leftRotate
                           (add32
                              A2
                              (eval Func2)
                              (get W (pop '*R160-R2))
                              Hex2 )
                           (pop '*R160-S2) )
                        E2 )
                     A1 E1
                     E1 D1
                     D1 (leftRotate C1 10)
                     C1 B1
                     B1 Tmp1

                     A2 E2
                     E2 D2
                     D2 (leftRotate C2 10)
                     C2 B2
                     B2 Tmp2 ) ) )
               (setq
                  Tmp (add32 H1 C1 D2)
                  H1 (add32 H2 D1 E2)
                  H2 (add32 H3 E1 A2)
                  H3 (add32 H4 A1 B2)
                  H4 (add32 H0 B1 C2)
                  H0 Tmp ) ) )
      (make
         (for N (list H0 H1 H2 H3 H4)
            (do 4
               (link (& N 255))
               (setq N (>> 8 N)) ) ) ) ) )

(let Str "Rosetta Code"
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (ripemd160 Str) ) ) )
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (native
               "libcrypto.so"
               "RIPEMD160"
               '(B . 20)
               Str
               (length Str)
               '(NIL (20)) ) ) ) ) )

(bye)
