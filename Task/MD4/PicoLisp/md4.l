(de *Md4-W .
   (1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
   1  5  9 13  2  6 10 14  3  7 11 15  4  8 12 16
   1  9  5 13  3 11  7 15  2 10  6 14  4 12  8 16 .))
(de *Md4-R1 . (3  7 11 19 .))
(de *Md4-R2 . (3  5  9 13 .))
(de *Md4-R3 . (3  9 11 15 .))

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de not32 (N)
   (x| N `(hex "FFFFFFFF")) )

(de add32 @
   (mod32 (pass +)) )

(de leftRotate (X C)
   (| (mod32 (>> (- C) X)) (>> (- 32 C) X)) )

(de md4 (Str)
   (let Len (length Str)
      (setq Str
         (conc
            (need
               (- 8 (* 64 (/ (+ Len 1 8 63) 64)))  # Pad to 64-8 bytes
               (conc
                  (mapcar char (chop Str))   # Works only with ASCII characters
                  (cons `(hex "80")) )       # '1' bit
               0 )                           # Pad with '0'
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
         R2 `(hex "5A827999")
         R3 `(hex "6ED9EBA1") )
      (while Str
         (let
            (A H0  B H1  C H2  D H3
               W (make
                    (do 16
                       (link
                          (apply |
                          (mapcar >> (0 -8 -16 -24) (cut 4 'Str)) ) ) ) ) )
            (for I 12
               (cond
                  ((>= 4 I)
                     (setq
                        A (leftRotate
                             (add32
                                A
                                (| (& B C) (& (not32 B) D))
                                (get W (pop '*Md4-W)) )
                             (pop '*Md4-R1) )
                        D (leftRotate
                             (add32
                                D
                                (| (& A B) (& (not32 A) C))
                                (get W (pop '*Md4-W)) )
                             (pop '*Md4-R1) )
                        C (leftRotate
                             (add32
                                C
                                (| (& D A) (& (not32 D) B))
                                (get W (pop '*Md4-W)) )
                             (pop '*Md4-R1) )
                        B (leftRotate
                             (add32
                                B
                                (| (& C D) (& (not32 C) A))
                                (get W (pop '*Md4-W)) )
                             (pop '*Md4-R1) ) ) )
                  ((>= 8 I)
                     (setq
                        A (leftRotate
                             (add32
                                A
                                (|
                                   (& B (| C D))
                                   (& C D) )
                                (get W (pop '*Md4-W))
                                R2 )
                             (pop '*Md4-R2) )
                        D (leftRotate
                             (add32
                                D
                                (|
                                   (& A (| B C))
                                   (& B C) )
                                (get W (pop '*Md4-W))
                                R2 )
                             (pop '*Md4-R2) )
                        C (leftRotate
                             (add32
                                C
                                (|
                                   (& D (| A B))
                                   (& A B) )
                                (get W (pop '*Md4-W))
                                R2 )
                             (pop '*Md4-R2) )
                        B (leftRotate
                             (add32
                                B
                                (|
                                   (& C (| D A))
                                   (& D A) )
                                (get W (pop '*Md4-W))
                                R2 )
                             (pop '*Md4-R2) ) ) )
                  (T
                     (setq
                        A (leftRotate
                             (add32
                                A
                                (x| B C D)
                                (get W (pop '*Md4-W))
                                R3 )
                             (pop '*Md4-R3) )
                        D (leftRotate
                             (add32
                                D
                                (x| A B C)
                                (get W (pop '*Md4-W))
                                R3 )
                             (pop '*Md4-R3) )
                        C (leftRotate
                             (add32
                                C
                                (x| D A B)
                                (get W (pop '*Md4-W))
                                R3 )
                             (pop '*Md4-R3) )
                        B (leftRotate
                             (add32
                                B
                                (x| C D A)
                                (get W (pop '*Md4-W))
                                R3 )
                             (pop '*Md4-R3) ) ) ) ) )
               (setq
                  H0 (add32 H0 A)
                  H1 (add32 H1 B)
                  H2 (add32 H2 C)
                  H3 (add32 H3 D) ) ) )
      (make
         (for N (list H0 H1 H2 H3)
            (do 4
               (link (& N 255))
               (setq N (>> 8 N)) ) ) ) ) )

(let Str "Rosetta Code"
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (md4 Str) ) ) )
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (native
               "libcrypto.so"
               "MD4"
               '(B . 16)
               Str
               (length Str)
               '(NIL (16)) ) ) ) ) )

(bye)
