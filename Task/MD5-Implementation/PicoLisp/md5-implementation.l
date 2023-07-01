(scl 12)
(load "@lib/math.l")  # For 'sin'

(de *Md5-R
   7 12 17 22  7 12 17 22  7 12 17 22  7 12 17 22
   5  9 14 20  5  9 14 20  5  9 14 20  5  9 14 20
   4 11 16 23  4 11 16 23  4 11 16 23  4 11 16 23
   6 10 15 21  6 10 15 21  6 10 15 21  6 10 15 21 )

(de *Md5-K
   ~(make
      (for I 64
         (link
            (/ (* (abs (sin (* I 1.0))) `(** 2 32)) 1.0) ) ) ) )

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de not32 (N)
   (x| N `(hex "FFFFFFFF")) )

(de add32 @
   (mod32 (pass +)) )

(de leftRotate (X C)
   (| (mod32 (>> (- C) X)) (>> (- 32 C) X)) )

(de md5 (Str)
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
         H3 `(hex "10325476") )
      (while Str
         (let
            (A H0  B H1  C H2  D H3
               W (make
                  (do 16
                     (link
                        (apply |
                           (mapcar >> (0 -8 -16 -24) (cut 4 'Str)) ) ) ) ) )
               (use (Tmp F G)
                  (for I 64
                     (cond
                        ((>= 16 I)
                           (setq
                              F (| (& B C) (& (not32 B) D))
                              G I ) )
                        ((>= 32 I)
                           (setq
                              F (| (& D B) (& (not32 D) C))
                              G (inc (& (inc (* 5 (dec I))) 15)) ) )
                        ((>= 48 I)
                           (setq
                              F (x| B C D)
                              G (inc (& (+ 5 (* 3 (dec I))) 15)) ) )
                        (T
                           (setq
                              F (x| C (| B (not32 D)))
                              G (inc (& (* 7 (dec I)) 15)) ) ) )
                     (setq
                        Tmp D
                        D C
                        C B
                        B
                        (add32 B
                           (leftRotate
                              (add32 A F (get *Md5-K I) (get W G))
                              (get *Md5-R I) ) )
                        A Tmp ) ) )
               (setq
                  H0 (add32 H0 A)
                  H1 (add32 H1 B)
                  H2 (add32 H2 C)
                  H3 (add32 H3 D) ) ) )
      (pack
         (make
            (for N (list H0 H1 H2 H3)
               (do 4  # Convert to little endian hex string
                  (link (pad 2 (hex (& N 255))))
                  (setq N (>> 8 N)) ) ) ) ) ) )
