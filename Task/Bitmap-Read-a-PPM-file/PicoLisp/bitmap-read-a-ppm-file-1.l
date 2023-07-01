(de ppmRead (File)
   (in File
      (unless (and `(hex "5036") (rd 2))  # P6
         (quit "Wrong file format" File) )
      (rd 1)
      (let (DX 0  DY 0  Max 0  C)
         (while (>= 9 (setq C (- (rd 1) `(char "0"))) 0)
            (setq DX (+ (* 10 DX) C)) )
         (while (>= 9 (setq C (- (rd 1) `(char "0"))) 0)
            (setq DY (+ (* 10 DY) C)) )
         (while (>= 9 (setq C (- (rd 1) `(char "0"))) 0)
            (setq Max (+ (* 10 Max) C)) )
         (prog1
            (make (do DY (link (need DX))))
            (for Y @
               (map
                  '((X) (set X (list (rd 1) (rd 1) (rd 1))))
                  Y ) ) ) ) ) )
