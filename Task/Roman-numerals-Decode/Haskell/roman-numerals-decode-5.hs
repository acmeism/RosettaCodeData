import Data.List (mapAccumR)
import Data.Map.Strict as M
import Data.Maybe (maybe)

fromRoman :: String -> Maybe Int
fromRoman cs =
  let go l r
        | l > r = (-r, l)
        | otherwise = (r, l)
  in traverse (`M.lookup` mapRoman) cs >>=
     (Just . sum . ((:) <$> fst <*> snd) . mapAccumR go 0)

mapRoman :: Map Char Int
mapRoman = M.fromList $ zip "MDCLXVI " [1000, 500, 100, 50, 10, 5, 1, 0]

-- TEST ---------------------------------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Decoding Roman numbers:\n"
    show
    (maybe "Unrecognised character" show)
    fromRoman
    ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVIII", "MMXBIII"]

-- FORMATTING ---------------------------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let w = maximum (length . xShow <$> xs)
      rjust n c = drop <$> length <*> (replicate n c ++)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
