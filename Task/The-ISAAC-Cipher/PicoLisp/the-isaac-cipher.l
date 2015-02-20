(de add32 @
   (mod32 (pass +)) )

(de mod32 (N)
   (& N `(hex "FFFFFFFF")) )

(de isaac()
   (let (Y 0  S (-13 6 -2 16 .))
      (setq *CC (add32 *CC 1))
      (setq *BB (add32 *BB *CC))
      (for (I . X) *MM
         (set (nth *MM I)
            (setq Y
               (add32
                  (get *MM (inc (% (>> 2 X) 256)))
                  (setq *AA
                     (add32
                        (x| *AA (>> (pop 'S) *AA))
                        (get *MM (inc (% (+ 127 I) 256))) ) )
                  *BB ) ) )
         (set (nth *RR I)
            (setq *BB
               (add32
                  (get *MM (inc (% (>> 10 Y) 256)))
                  X ) ) ) ) ) )

(de mixA()
   (let S (-11 2 -8 16 -10 4 -8 9 .)
      (for I 8
         (set (nth *A I)
            (mod32
               (x|
                  (get *A I)
                  (mod32
                     (>>
                        (pop 'S)
                        (get *A (inc (% I 8))) ) ) ) ) )
         (set (nth *A (inc (% (+ 2 I) 8)))
            (add32
               (get *A (inc (% (+ 2 I) 8)))
               (get *A I) ) )
         (set (nth *A (inc (% I 8)))
            (add32
               (get *A (inc (% I 8)))
               (get *A (inc (% (inc I) 8))) ) ) ) ) )

(de iseed ()
   (do 4
      (mixA) )
   (for (I 1 (> 256 I) (inc 'I 8))
      (for (J I (> (+ 8 I) J) (inc J))
         (set (nth *A (inc (% (dec J) 8)))
            (add32
               (get *A (inc (% (dec J) 8)))
               (get *RR J) ) ) )
      (mixA)
      (for (J I (> (+ 8 I) J) (inc J))
         (set (nth *MM J)
            (get *A (inc (% (dec J) 8))) ) ) )
   (for (I 1 (> 256 I) (inc 'I 8))
      (for (J I (> (+ 8 I) J) (inc J))
         (set (nth *A (inc (% (dec J) 8)))
            (add32
               (get *A (inc (% (dec J) 8)))
               (get *MM J) ) ) )
      (mixA)
      (for (J I (> (+ 8 I) J) (inc J))
         (set (nth *MM J)
            (get *A (inc (% (dec J) 8))) ) ) )
   (isaac) )

(let
   (*AA 0
      *BB 0
      *CC 0
      *MM (need 256 0)
      *RC 0
      *RR (need
            -256
            (mapcar
               char
               (head 256 (chop "this is my secret key")) ) 0 )
      *A (need 8 `(hex "9E3779B9")) )
   (iseed)
   (println
      (pack
         (mapcar
            '((B) (pad 2 (hex B)))
            (make
               (for I (mapcar char (chop "a Top Secret secret"))
                  (link
                     (x|
                        I
                        (+
                           32
                           (%
                              (get
                                 *RR
                                 (if (>= 256 (inc '*RC))
                                    *RC
                                    (isaac)
                                    (one *RC) ) )
                              95 ) ) ) ) ) ) ) ) ) )

(bye)
