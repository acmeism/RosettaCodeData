import qualified Data.Map.Strict as M
import Data.List (find, intercalate)
import Data.Maybe (maybe)


------------- EULER'S SUM OF POWERS CONJECTURE -----------

counterExample :: (M.Map Int (Int, Int), M.Map Int Int) -> Maybe (Int, Int)
counterExample (sumMap, powerMap) =
  find
    (\(p, s) -> M.member (p - s) sumMap)
    (M.keys powerMap >>=
     (((>>=) . flip takeWhile (M.keys sumMap) . (>)) <*> \ p s -> [(p, s)]))

sumMapForRange :: [Int] -> M.Map Int (Int, Int)
sumMapForRange xs =
  M.fromList
    [ ((x ^ 5) + (y ^ 5), (x, y))
    | x <- xs
    , y <- tail xs
    , x > y ]

powerMapForRange :: [Int] -> M.Map Int Int
powerMapForRange = M.fromList . (zip =<< fmap (^ 5))


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
  "Euler's sum of powers conjecture – " <>
  maybe
    ("no counter-example found in the range " <> rangeString xs)
    (showExample sumsAndPowers xs)
    (counterExample sumsAndPowers)
  where
    xs = [1 .. 249]
    sumsAndPowers = ((,) . sumMapForRange <*> powerMapForRange) xs

showExample :: (M.Map Int (Int, Int), M.Map Int Int) -> [Int] -> (Int, Int) -> String
showExample (sumMap, powerMap) xs (p, s) =
  "a counter-example in range " <> rangeString xs <> ":\n\n" <>
  intercalate "^5 + " (show <$> [a, b, c, d]) <>
  "^5 = " <>
  show (powerMap M.! p) <>
  "^5"
  where
    (a, b) = sumMap M.! (p - s)
    (c, d) = sumMap M.! s

rangeString :: [Int] -> String
rangeString [] = "[]"
rangeString (x:xs) = '[' : show x <> " .. " <> show (last xs) <> "]"
