(load "@lib/simul.l")
(seed (in "/dev/urandom" (rd 8)))
(de pieceN (P)
   (case P
      ("p" 8)
      ("q" 1)
      (T 2) ) )
(de pieceset ()
   (let C 0
      (make
         (for P (conc (cons "p") (shuffle '("r" "n" "b" "q")))
            (let (X (pieceN P)  N (rand 0 (+ X C)))
               (do N
                  (link P) )
               (if (= P "p")
                  (and
                     (> X N)
                     (inc 'C (- X N)) )
                  (and
                     (> N X)
                     (dec 'C (- N X)) ) ) ) ) ) ) )
(de neib (A)
   (let
      (X (/ (dec A) 8)
         Y (% (dec A) 8) )
      (filter
         '((N)
            (and
               (<= 1 N 64)
               (<=
                  (abs (- (/ (dec N) 8) X))
                  1 )
               (<=
                  (abs (- (% (dec N) 8) Y))
                  1 ) ) )
         (mapcar
            '((B) (+ B A))
            (-9 -8 -7 -1 1 7 8 9) ) ) ) )
(setq *B (need 64 "."))
(setq *P (conc (pieceset) (mapcar uppc (pieceset)) (cons "K")))
(for P *P
   (loop
      (T
         (=
            "."
            (car
               (setq @@
                  (nth
                     *B
                     (apply
                        rand
                        (if (or (= "p" P) (= "P" P))
                           (9 56)
                           (1 64) ) ) ) ) ) )
         (set @@ P) ) ) )
(loop
   (T
      (and
         (=
            "."
            (car
               (setq @@ (nth *B (setq @@@ (rand 1 64)))) ) )
         (fully
            '((N) (<> "K" (get *B N)))
            (neib @@@) ) )
      (set @@ "k") ) )
(setq *FEN
   (make
      (while *B
         (let (C 0  Lst (cut 8 '*B))
            (prinl Lst)
            (link
               (make
                  (for L Lst
                     (if (= L ".")
                        (inc 'C)
                        (and
                           (gt0 C)
                           (link (swap 'C 0)) )
                        (link L) ) )
                  (and
                     (gt0 C)
                     (link C) ) ) ) ) ) ) )
(println (pack (glue "/" *FEN) " w - - 0 1"))
