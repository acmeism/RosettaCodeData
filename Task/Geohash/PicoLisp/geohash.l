(scl 20)
(setq *GBASE32 (chop "0123456789bcdefghjkmnpqrstuvwxyz"))
(de encode (Lat Lng Prec)
   (let
      (Base (circ (list -180.0 180.0) (list -90.0 90.0))
         Curr (circ Lng Lat)
         Lst
         (make
            (do (* 5 Prec)
               (let
                  (B (++ Base)
                     C (++ Curr)
                     M (/ (sum prog B) 2) )
                  (if (> C M)
                     (prog (set B M) (link 1))
                     (set (cdr B) M)
                     (link 0) ) ) ) ) )
      (pack
         (make
            (for (L Lst L)
               (link
                  (get
                     *GBASE32
                     (inc (bin (pack (cut 5 'L)))) ) ) ) ) ) ) )
(println (encode 51.433718 -0.214126 2))
(println (encode 51.433718 -0.214126 9))
(println (encode 57.649110 10.407440 11))
