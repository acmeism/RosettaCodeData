(load "@lib/simul.l")

(de maze (DX DY)
   (let Maze (grid DX DY)
      (let Fld (get Maze (rand 1 DX) (rand 1 DY))
         (recur (Fld)
            (for Dir (shuffle '((west . east) (east . west) (south . north) (north . south)))
               (with ((car Dir) Fld)
                  (unless (or (: west) (: east) (: south) (: north))
                     (put Fld (car Dir) This)
                     (put This (cdr Dir) Fld)
                     (recurse This) ) ) ) ) )
      (for (X . Col) Maze
         (for (Y . This) Col
            (set This
               (cons
                  (cons
                     (: west)
                     (or
                        (: east)
                        (and (= Y 1) (= X DX)) ) )
                  (cons
                     (: south)
                     (or
                        (: north)
                        (and (= X 1) (= Y DY)) ) ) ) ) ) )
      Maze ) )

(de display (Maze)
   (disp Maze 0 '((This) "   ")) )
