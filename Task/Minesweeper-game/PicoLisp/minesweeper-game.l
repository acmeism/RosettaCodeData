# NIL    Hidden: Empty field
# T      Hidden: Mine
# 0-8    Marked: Empty field
# ?      Marked: Mine

(de minesweeper (DX DY Density)
   (default Density 20)
   (setq *Field (make (do DY (link (need DX)))))
   (use (X Y)
      (do (prinl "Number of mines: " (*/ DX DY Density 100))
         (while
            (get *Field
               (setq Y (rand 1 DY))
               (setq X (rand 1 DX)) ) )
         (set (nth *Field Y X) T) ) )
   (showMines) )

(de showMines ()
   (for L *Field
      (for F L
         (prin (if (flg? F) "." F)) )
      (prinl) ) )

(de *NeighborX -1  0 +1 -1  +1 -1  0 +1)
(de *NeighborY -1 -1 -1  0   0 +1 +1 +1)

(de c (X Y)
   (if (=T (get *Field Y X))
      "KLABOOM!! You hit a mine."
      (let Visit NIL
         (recur (X Y)
            (when
               (=0
                  (set (nth *Field Y X)
                     (cnt
                        '((DX DY)
                           (=T (get *Field (+ Y DY) (+ X DX))) )
                        *NeighborX
                        *NeighborY ) ) )
               (mapc
                  '((DX DY)
                     (and
                        (get *Field (inc 'DY Y))
                        (nth @ (inc 'DX X))
                        (not (member (cons DX DY) Visit))
                        (push 'Visit (cons DX DY))
                        (recurse DX DY) ) )
                  *NeighborX
                  *NeighborY ) ) ) )
      (showMines) ) )

(de m (X Y)
   (set (nth *Field Y X) '?)
   (showMines)
   (unless (fish =T *Field)
      "Congratulations! You won!!" ) )
