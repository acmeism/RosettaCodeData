(load "@lib/simul.l")

# Display board
(de display ()
   (disp *Board NIL
      '((This)
         (pack
            (if2 (== This *Pos) (memq This *Goals)
               "+"                   # Player on goal
               "@"                   # Player elsewhere
               (if (: val) "*" ".")  # On gloal
               (or (: val) " ") )    # Elsewhere
            " " ) ) ) )

# Initialize
(de main (Lst)
   (mapc
      '((B L)
         (mapc
            '((This C)
               (case C
                  (" ")
                  ("." (push '*Goals This))
                  ("@" (setq *Pos This))
                  ("$" (=: val C) (push '*Boxes This))
                  (T (=: val C)) ) )
               B L ) )
      (setq *Board (grid (length (car Lst)) (length Lst)))
      (apply mapcar (flip (mapcar chop Lst)) list) )
   (display) )

# Generate possible push-moves
(de pushes ()
   (make
      (for Box *Boxes
         (unless (or (; (west Box) val) (; (east Box) val))
            (when (moves (east Box))
               (link (cons (cons Box (west Box)) *Pos "L" @)) )
            (when (moves (west Box))
               (link (cons (cons Box (east Box)) *Pos "R" @)) ) )
         (unless (or (; (south Box) val) (; (north Box) val))
            (when (moves (north Box))
               (link (cons (cons Box (south Box)) *Pos "D" @)) )
            (when (moves (south Box))
               (link (cons (cons Box (north Box)) *Pos "U" @)) ) ) ) ) )

# Moves of player to destination
(de moves (Dst Hist)
   (or
      (== Dst *Pos)
      (mini length
         (extract
            '((Dir)
               (with ((car Dir) Dst)
                  (cond
                     ((== This *Pos) (cons (cdr Dir)))
                     ((: val))
                     ((memq This Hist))
                     ((moves This (cons Dst Hist))
                        (cons (cdr Dir) @) ) ) ) )
            '((west . "r") (east . "l") (south . "u") (north . "d")) ) ) ) )

# Find solution
(de go (Res)
   (unless (idx '*Hist (sort (copy *Boxes)) T)  # No repeated state
      (if (find '((This) (<> "$" (: val))) *Goals)
         (pick
            '((Psh)
               (setq  # Move
                  *Pos (caar Psh)
                  *Boxes (cons (cdar Psh) (delq *Pos *Boxes)) )
               (put *Pos 'val NIL)
               (put (cdar Psh) 'val "$")
               (prog1 (go (append (cddr Psh) Res))
                  (setq  # Undo move
                     *Pos (cadr Psh)
                     *Boxes (cons (caar Psh) (delq (cdar Psh) *Boxes)) )
                  (put (cdar Psh) 'val NIL)
                  (put (caar Psh) 'val "$") ) )
            (pushes) )
         (display)  # Display solution
         (pack (flip Res)) ) ) )
