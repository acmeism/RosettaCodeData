(load "@lib/simul.l")

(symbols 'simul 'pico)

(seed (in "/dev/urandom" (rd 8)))

(setq *G (grid 4 4)  *D NIL)

(de cell ()
   (use This
      (while
         (get
            (setq This
               (intern
                  (pack
                     (char (+ 96 (rand 1 4)))
                     (rand 1 4) ) ) )
            'N ) )
      (=: N (if (> 90 (rand 1 100)) 2 4) ) )
   (setq *D (fish '((This) (: N)) *G)) )

(de redraw (G S D)
   # zeroize *G
   (mapc
      '((I)
         (mapc '((This) (=: N NIL)) I) )
      *G )
   # draw again
   (mapc
      '((X This)
         (while (and This X)
            (=: N (pop 'X))
            (setq This (D This)) ) )
      G
      S ) )

(de summ (Lst)
   (mapcar
      '((L)
         (make
            (while L
               (ifn (= (car L) (cadr L))
                  (link (car L))
                  (link (+ (car L) (cadr L)))
                  (pop 'L) )
               (pop 'L) ) ) )
      Lst ) )

(de vertical ()
   (mapcar
      '((X) (extract '((This) (: N)) X))
      *G ) )

(de horizontal ()
   (mapcar
      '((This)
         (make
            (while This
               (when (: N) (link @))
               (setq This (east This)) ) ) )
      (car *G) ) )

(de finish? ()
   (nor
      (fish
         '((This)
            (when (atom This) (= NIL (: N))) )
         *G )
      (find
         '((L)
            (find
               '((This)
                  (when (: N)
                     (find
                        '((D)
                           (= (: N) (get (D This) 'N)) )
                        (quote north south west east) ) ) )
               L ) )
         *G ) ) )

(de board (D)
   (space 3)
   (prin '+)
   (for I G
      (prin (if (D (car I)) "   +" "---+")) )
   (prinl) )

(de display ()
   (let G (mapcar reverse *G)
      (board north)
      (while (caar G)
         (space 3)
         (prin '|)
         (for I G
            (with (car I)
               (prin
                  (if (: N) (align 3 (: N)) "   ")
                  (if (east This) " " '|) ) ) )
         (prinl)
         (board south)
         (map pop G) )
      (do 2
         (prinl) ) ) )

(do 2
   (cell) )
(display)
(loop
   (case
      (pack
         (make
            (link (key))
            (while (key 100)
               (link @) ) ) )
      ("^[[D" #left
         (redraw (summ (horizontal)) '(a1 a2 a3 a4) east) )
      ("^[[C" #rigth
         (redraw
            (summ (mapcar reverse (horizontal)))
            '(d1 d2 d3 d4)
            west) )
      ("^[[B" #down
         (redraw (summ (vertical)) '(a1 b1 c1 d1) north) )
      ("^[[A" #up
         (redraw
            (summ (mapcar reverse (vertical)))
            '(a4 b4 c4 d4)
            south) ) )
   (when (diff *D (fish '((This) (: N)) *G))
      (cell) )
   (display)
   (T (finish?) (println 'Finish))
   (T (fish '((This) (= 512 (: N))) *G)
      (println 'Maximum) ) )
(bye)
