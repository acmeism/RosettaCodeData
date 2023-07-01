--import should go to the top of the code
import Graphics.Gloss

main = display (InWindow "Pithagoras tree" (400, 400) (0, 0)) white tree
  where tree = foldMap lineLoop squares
