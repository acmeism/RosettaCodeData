import qualified Data.Map.Strict as M
import Data.Maybe (maybe)
import Data.Bool (bool)


mapRoman :: M.Map Char Int
mapRoman = M.fromList $ zip "IVXLCDM" $ scanl (*) 1 (cycle [5, 2])


fromRoman :: String -> Maybe Int
fromRoman cs =
  traverse (`M.lookup` mapRoman) cs >>=
  (Just . snd . foldr (\l (r, n) -> (l, bool (-) (+) (l >= r) n l)) (0, 0))


-- TEST ---------------------------------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Roman numeral decoding as a right fold:\n"
    show
    (maybe "(Unrecognised character seen)" show)
    fromRoman
    ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII", "QQXVII"]

-- FORMATTING ---------------------------------------------

fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let w = maximum (length . xShow <$> xs)
      rjust n c = drop <$> length <*> (replicate n c ++)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
