(load "@lib/simul.l")
(seed (in "/dev/urandom" (rd 8)))
(scl 6)
# N - number
# C - Color
# F - flag to draw candidates
# A - @ mark
(de display ()
   (let P 0
      (wait 500)
      (prin "^[[2J")
      (for L G
         (for This L
            # count cleared cells
            (and (lt0 (: N)) (inc 'P))
            (prin
               "^[[0;"
               (if (or (: A) (: F)) 100 (: C))
               "m"
               (cond
                  ((: A) "@")
                  ((lt0 (: N)) " ")
                  (T (: N)) )
               "^[[0m" ) )
         (prinl) )
      (prinl
         "Score:     "
         S
         "       "
         (round (*/ P 1.0 100.0 1738.0) 2)
         "%" ) ) )
(de roads (Lst Flg)
   (mapc
      '((L)
         (with C
            (do (car L)
               (setq This ((cadr L) This))
               (=: F Flg) ) ) )
      Lst )
   (display) )
(let
   (Colors (simul~shuffle (31 32 33 35 91 92 93 94 96))
      G (simul~grid 22 79)
      C NIL
      S 0 )
   # set random grid
   (for L G
      (for This L
         (let X (rand 1 9)
            (=: N X)
            (=: C (get Colors X)) ) ) )
   # set random startpoint
   (with (get G (rand 1 22) (rand 1 79))
      (setq C This)
      (=: A 0) )
   (display)
   (loop
      (NIL
         (setq Z
            (extract
               '((D)
                  (with C
                     (let? S (with (D This) (: N))
                        (and
                           (do S
                              (NIL (setq This (D This)))
                              (NIL (gt0 (: N)))
                              'next )
                           (list S D This) ) ) ) )
               '(simul~west
                  simul~east
                  simul~south
                  simul~north
                  ((X) (simul~south (simul~west X)))
                  ((X) (simul~north (simul~west X)))
                  ((X) (simul~south (simul~east X)))
                  ((X) (simul~north (simul~east X))) ) ) ) )
         # XXX
         (roads Z T)
         (roads Z)
         # select road randomly
         (let L (get Z (rand 1 (length Z)))
            (with C
               (inc 'S (: N))
               # clear value of "old" Center
               (=: N -1)
               (=: A)
               # clear selected road
               (do (car L)
                  (inc 'S (: N))
                  (=: N -1)
                  (setq This ((cadr L) This)) ) )
            # set new Center
            (with (caddr L)
               (setq C This)
               (=: A 0) ) )
         (display) ) )
(bye)
