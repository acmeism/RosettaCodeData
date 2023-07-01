import Data.List (groupBy)
import Data.Function (on)
import Control.Monad (join)

main :: IO ()
main =
  mapM_ print $
  fmap (uncurry (*)) <$>
  groupBy
    (on (==) fst)
    (filter (uncurry (>=)) $ join ((<*>) . fmap (,)) [1 .. 12])
