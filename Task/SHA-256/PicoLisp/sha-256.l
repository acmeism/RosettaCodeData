(setq *Sha256-K
   (mapcar hex
      '("428A2F98" "71374491" "B5C0FBCF" "E9B5DBA5" "3956C25B"
        "59F111F1" "923F82A4" "AB1C5ED5" "D807AA98" "12835B01"
        "243185BE" "550C7DC3" "72BE5D74" "80DEB1FE" "9BDC06A7"
        "C19BF174" "E49B69C1" "EFBE4786" "0FC19DC6" "240CA1CC"
        "2DE92C6F" "4A7484AA" "5CB0A9DC" "76F988DA" "983E5152"
        "A831C66D" "B00327C8" "BF597FC7" "C6E00BF3" "D5A79147"
        "06CA6351" "14292967" "27B70A85" "2E1B2138" "4D2C6DFC"
        "53380D13" "650A7354" "766A0ABB" "81C2C92E" "92722C85"
        "A2BFE8A1" "A81A664B" "C24B8B70" "C76C51A3" "D192E819"
        "D6990624" "F40E3585" "106AA070" "19A4C116" "1E376C08"
        "2748774C" "34B0BCB5" "391C0CB3" "4ED8AA4A" "5B9CCA4F"
        "682E6FF3" "748F82EE" "78A5636F" "84C87814" "8CC70208"
        "90BEFFFA" "A4506CEB" "BEF9A3F7" "C67178F2") ) )

(de rightRotate (X C)
   (| (mod32 (>> C X)) (mod32 (>> (- C 32) X))) )

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de not32 (N)
   (x| N `(hex "FFFFFFFF")) )

(de add32 @
   (mod32 (pass +)) )

(de sha256 (Str)
   (let Len (length Str)
      (setq Str
         (conc
            (need
               (-
                  8
                  (* 64 (/ (+ Len 1 8 63) 64)) )
               (conc (mapcar char (chop Str)) (cons `(hex "80")))
               0 )
            (flip
               (make
                  (setq Len (* 8 Len))
                  (do 8
                     (link (& Len 255))
                     (setq Len (>> 8 Len )) ) ) ) ) ) )
   (let
      (H0 `(hex "6A09E667")
         H1 `(hex "BB67AE85")
         H2 `(hex "3C6EF372")
         H3 `(hex "A54FF53A")
         H4 `(hex "510E527F")
         H5 `(hex "9B05688C")
         H6 `(hex "1F83D9AB")
         H7 `(hex "5BE0CD19") )
      (while Str
         (let
            (A H0
               B H1
               C H2
               D H3
               E H4
               F H5
               G H6
               H H7
               W
               (conc
                 (make
                    (do 16
                       (link
                          (apply
                             |
                             (mapcar >> (-24 -16 -8 0) (cut 4 'Str)) ) ) ) )
                 (need 48 0) ) )
               (for (I 17 (>= 64 I) (inc I))
                  (let
                     (Wi15 (get W (- I 15))
                        Wi2 (get W (- I 2))
                        S0
                        (x|
                           (rightRotate Wi15 7)
                           (rightRotate Wi15 18)
                           (>> 3 Wi15) )
                        S1
                        (x|
                           (rightRotate Wi2 17)
                           (rightRotate Wi2 19)
                           (>> 10 Wi2) ) )
                     (set (nth W I)
                        (add32
                           (get W (- I 16))
                           S0
                           (get W (- I 7))
                           S1 ) ) ) )
               (use (Tmp1 Tmp2)
                  (for I 64
                     (setq
                        Tmp1
                        (add32
                           H
                           (x|
                              (rightRotate E 6)
                              (rightRotate E 11)
                              (rightRotate E 25) )
                           (x| (& E F) (& (not32 E) G))
                           (get *Sha256-K I)
                           (get W I) )
                        Tmp2
                        (add32
                           (x|
                              (rightRotate A 2)
                              (rightRotate A 13)
                              (rightRotate A 22) )
                           (x|
                              (& A B)
                              (& A C)
                              (& B C) ) )
                        H G
                        G F
                        F E
                        E (add32 D Tmp1)
                        D C
                        C B
                        B A
                        A (add32 Tmp1 Tmp2) ) ) )
               (setq
                  H0 (add32 H0 A)
                  H1 (add32 H1 B)
                  H2 (add32 H2 C)
                  H3 (add32 H3 D)
                  H4 (add32 H4 E)
                  H5 (add32 H5 F)
                  H6 (add32 H6 G)
                  H7 (add32 H7 H) ) ) )
      (mapcan
         '((N)
            (flip
               (make
                  (do 4
                     (link (& 255 N))
                     (setq N (>> 8 N)) ) ) ) )
         (list H0 H1 H2 H3 H4 H5 H6 H7) ) ) )

(let Str "Rosetta code"
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (sha256 Str) ) ) )
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (native
               "libcrypto.so"
               "SHA256"
               '(B . 32)
               Str
               (length Str)
               '(NIL (32)) ) ) ) ) )

(bye)
