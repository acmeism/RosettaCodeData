import Diagrams.Prelude
import Diagrams.Backend.SVG.CmdLine

drawTable tbl = foldl1 (===) $ map (foldl1 (|||)) tbl :: Diagram B

dots x = (circle 1 # if isPrime x then fc black else fc white) :: Diagram B

main = mainWith $ drawTable $ ulam 100 dots [1..]
