(de leftRotate (X C)
   (| (mod32 (>> (- C) X)) (>> (- 32 C) X)) )

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de not32 (N)
   (x| N `(hex "FFFFFFFF")) )

(de add32 @
   (mod32 (pass +)) )

(de sha1 (Str)
   (let Len (length Str)
      (setq Str
         (conc
            (need
               (-
                  8
                  (* 64 (/ (+ Len 1 8 63) 64)) )
               (conc
                  (mapcar char (chop Str))
                  (cons `(hex "80")) )
               0 )
            (flip
               (make
                  (setq Len (* 8 Len))
                  (do 8
                     (link (& Len 255))
                     (setq Len (>> 8 Len )) ) ) ) ) ) )
   (let
      (H0 `(hex "67452301")
         H1 `(hex "EFCDAB89")
         H2 `(hex "98BADCFE")
         H3 `(hex "10325476")
         H4 `(hex "C3D2E1F0") )
      (while Str
         (let
            (A H0  B H1  C H2  D H3  E H4
               W (conc
                    (make
                       (do 16
                          (link
                             (apply
                                |
                                (mapcar >> (-24 -16 -8 0) (cut 4 'Str)) ) ) ) )
                  (need 64 0) ) )
               (for (I 17 (>= 80 I) (inc I))
                  (set (nth W I)
                     (leftRotate
                        (x|
                           (get W (- I 3))
                           (get W (- I 8))
                           (get W (- I 14))
                           (get W (- I 16)) )
                        1 ) ) )
               (use (Tmp F K)
                  (for I 80
                     (cond
                        ((>= 20 I)
                           (setq
                              F (| (& B C) (& (not32 B) D))
                              K `(hex "5A827999") ) )
                        ((>= 40 I)
                           (setq
                              F (x| B C D)
                              K `(hex "6ED9EBA1") ) )
                        ((>= 60 I)
                           (setq
                              F (| (& B C) (& B D) (& C D))
                              K `(hex "8F1BBCDC") ) )
                        (T
                           (setq
                              F (x| B C D)
                              K `(hex "CA62C1D6") ) ) )
                     (setq
                        Tmp (add32 (leftRotate A 5) F E K (get W I) )
                        E D
                        D C
                        C (leftRotate B 30)
                        B A
                        A Tmp ) ) )
               (setq
                  H0 (add32 H0 A)
                  H1 (add32 H1 B)
                  H2 (add32 H2 C)
                  H3 (add32 H3 D)
                  H4 (add32 H4 E) ) ) )
      (mapcan
         '((N)
            (flip
               (make
                  (do 4
                     (link (& 255 N))
                     (setq N (>> 8 N)) ) ) ) )
         (list H0 H1 H2 H3 H4) ) ) )

(let Str "Rosetta Code"
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (sha1 Str) ) ) )
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (native
               "libcrypto.so"
               "SHA1"
               '(B . 20)
               Str
               (length Str)
               '(NIL (20)) ) ) ) ) )

(bye)
