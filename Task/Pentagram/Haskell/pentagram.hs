-- Extract the vertices of a pentagon, re-ordering them so that drawing lines
-- from one to the next forms a pentagram.  Set the line's thickness and its
-- colour, as well as the fill and background colours.  Make the background a
-- bit larger than the pentagram.

import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine

pentagram = let [a, b, c, d, e] = trailVertices $ pentagon 1
            in [a, c, e, b, d]
               # fromVertices
               # closeTrail
               # strokeTrail
               # lw ultraThick
               # fc springgreen
               # lc blue
               # bgFrame 0.2 bisque

main = mainWith (pentagram :: Diagram B)
