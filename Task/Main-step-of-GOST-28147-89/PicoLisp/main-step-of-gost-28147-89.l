(setq K1 (13  2  8  4  6 15 11  1 10  9  3 14  5  0 12  7))
(setq K2 ( 4 11  2 14 15  0  8 13  3 12  9  7  5 10  6  1))
(setq K3 (12  1 10 15  9  2  6  8  0 13  3  4 14  7  5 11))
(setq K4 ( 2 12  4  1  7 10 11  6  8  5  3 15 13  0 14  9))
(setq K5 ( 7 13 14  3  0  6  9 10  1  2  8  5 11 12  4 15))
(setq K6 (10  0  9 14  6  3 15  5  1 13 12  7 11  4  2  8))
(setq K7 (15  1  8 14  6 11  3  4  9  7  2 13 12  0  5 10))
(setq K8 (14  4 13  1  2 15 11  8  3 10  6 12  5  9  0  7))

(setq K21
   (mapcar
      '((N)
         (|
            (>> -4 (get K2 (inc (>> 4 N))))
            (get K1 (inc (& N 15))) ) )
      (range 0 255) ) )

(setq K43
   (mapcar
      '((N)
         (|
            (>> -4 (get K4 (inc (>> 4 N))))
            (get K3 (inc (& N 15))) ) )
      (range 0 255) ) )

(setq K65
   (mapcar
      '((N)
         (|
            (>> -4 (get K6 (inc (>> 4 N))))
            (get K5 (inc (& N 15))) ) )
      (range 0 255) ) )

(setq K87
   (mapcar
      '((N)
         (|
            (>> -4 (get K8 (inc (>> 4 N))))
            (get K7 (inc (& N 15))) ) )
      (range 0 255) ) )

(de leftRotate (X C)
   (|
      (& `(hex "FFFFFFFF") (>> (- C) X))
      (>> (- 32 C) X) ) )

(de f (X)
   (leftRotate
      (apply
         |
         (mapcar
            '((Lst N)
               (>>
                  N
                  (get
                     (val Lst)
                     (inc (& 255 (>> (abs N) X))) ) ) )
            '(K87 K65 K43 K21)
            (-24 -16 -8 0) ) )
      11 ) )

(bye)
