import Data.List (groupBy, maximumBy, sort)
import Data.Ord (comparing)
import Data.Function (on)
import Data.Text (pack)

main :: IO ()
main = do
  f <- readFile "./unixdict.txt"
  let ws = groupBy (on (==) fst) (sort (((,) =<< pack . sort) <$> lines f))
  mapM_
    (print . fmap snd)
    (filter ((length (maximumBy (comparing length) ws) ==) . length) ws)
