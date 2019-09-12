import Data.List (intercalate, unfoldr)
import Debug.Trace (trace)
import Data.Tuple (swap)
import Data.Bool (bool)

-- ETHIOPIAN MULTIPLICATION -------------------------------

ethMult :: Int -> Int -> Int
ethMult n m =
  let addedWhereOdd (d, x) a
        | 0 < d = (+) a x
        | otherwise = a
      halved h
        | 0 < h = Just $ trace (showHalf h) (swap $ quotRem h 2)
        | otherwise = Nothing
      doubled x = x + x
      pairs = zip (unfoldr halved n) (iterate doubled m)
  in (let x = foldr addedWhereOdd 0 pairs
      in trace (showDoubles pairs ++ " = " ++ show x ++ "\n") x)

-- TRACE DISPLAY -------------------------------------------

showHalf :: Int -> String
showHalf x = "halve: " ++ rjust 6 ' ' (show (quotRem x 2))

showDoubles :: [(Int, Int)] -> String
showDoubles xs =
  "double:\n" ++
  unlines
    (fmap
       (\x ->
           bool
             (rjust 6 ' ' $ show $ snd x)
             ("-> " ++ rjust 3 ' ' (show $ snd x))
             (0 < fst x))
       xs) ++
  intercalate " + " (xs >>= (\(r, q) -> bool [] [show q] (0 < r)))

rjust :: Int -> Char -> String -> String
rjust n c s = drop (length s) (replicate n c ++ s)

-- TEST ---------------------------------------------------
main :: IO ()
main = do
  print $ ethMult 17 34
  print $ ethMult 34 17
