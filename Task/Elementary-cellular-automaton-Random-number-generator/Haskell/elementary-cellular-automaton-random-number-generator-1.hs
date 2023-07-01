import CellularAutomata (fromList, rule, runCA)
import Control.Comonad
import Data.List (unfoldr)

rnd = fromBits <$> unfoldr (pure . splitAt 8) bits
  where
    size = 80
    bits =
      extract
        <$> runCA
          (rule 30)
          (fromList (1 : replicate size 0))

fromBits = foldl ((+) . (2 *)) 0
