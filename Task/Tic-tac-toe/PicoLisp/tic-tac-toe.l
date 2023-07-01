(load "@lib/simul.l")  # for 'game' function

(de display ()
   (for Y (3 2 1)
      (prinl "   +---+---+---+")
      (prin " " Y)
      (for X (1 2 3)
         (prin " | " (or (get *Board X Y) " ")) )
      (prinl " |") )
   (prinl "   +---+---+---+")
   (prinl "     a   b   c") )

(de find3 (P)
   (find
      '((X Y DX DY)
         (do 3
            (NIL (= P (get *Board X Y)))
            (inc 'X DX)
            (inc 'Y DY)
            T ) )
      (1 1 1 1 2 3 1 1)
      (1 2 3 1 1 1 1 3)
      (1 1 1 0 0 0 1 1)
      (0 0 0 1 1 1 1 -1) ) )

(de myMove ()
   (when
      (game NIL 8
         '((Flg)     # Moves
            (unless (find3 (or (not Flg) 0))
               (make
                  (for (X . L) *Board
                     (for (Y . P) L
                        (unless P
                           (link
                              (cons
                                 (cons X Y (or Flg 0))
                                 (list X Y) ) ) ) ) ) ) ) )
         '((Mov) # Move
            (set (nth *Board (car Mov) (cadr Mov)) (cddr Mov)) )
         '((Flg)     # Cost
            (if (find3 (or Flg 0)) -100 0) ) )
      (let Mov (caadr @)
         (set (nth *Board (car Mov) (cadr Mov)) 0) )
      (display) ) )

(de yourMove (X Y)
   (and
      (sym? X)
      (>= 3 (setq X (- (char X) 96)) 1)
      (num? Y)
      (>= 3 Y 1)
      (not (get *Board X Y))
      (set (nth *Board X Y) T)
      (display) ) )

(de main ()
   (setq *Board (make (do 3 (link (need 3)))))
   (display) )

(de go Args
   (cond
      ((not (yourMove (car Args) (cadr Args)))
         "Illegal move!" )
      ((find3 T) "Congratulation, you won!")
      ((not (myMove)) "No moves")
      ((find3 0) "Sorry, you lost!") ) )
