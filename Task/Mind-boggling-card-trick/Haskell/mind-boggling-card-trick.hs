import System.Random (randomRIO)
import Data.List (partition)
import Data.Monoid ((<>))

main :: IO [Int]
main = do

  -- DEALT
  ns <- knuthShuffle [1 .. 52]
  let (rs_, bs_, discards) = threeStacks (rb <$> ns)

  -- SWAPPED
  nSwap <- randomRIO (1, min (length rs_) (length bs_))
  let (rs, bs) = exchange nSwap rs_ bs_

  -- CHECKED
  let rrs = filter ('R' ==) rs
  let bbs = filter ('B' ==) bs
  putStrLn $
    unlines
      [ "Discarded: " <> discards
      , "Swapped: " <> show nSwap
      , "Red pile: " <> rs
      , "Black pile: " <> bs
      , rrs <> " = Red cards in the red pile"
      , bbs <> " = Black cards in the black pile"
      , show $ length rrs == length bbs
      ]
  return ns

-- RED vs BLACK ----------------------------------------
rb :: Int -> Char
rb n
  | even n = 'R'
  | otherwise = 'B'

-- THREE STACKS ----------------------------------------
threeStacks :: String -> (String, String, String)
threeStacks = go ([], [], [])
  where
    go tpl [] = tpl
    go (rs, bs, ds) [x] = (rs, bs, x : ds)
    go (rs, bs, ds) (x:y:xs)
      | 'R' == x = go (y : rs, bs, x : ds) xs
      | otherwise = go (rs, y : bs, x : ds) xs

exchange :: Int -> [a] -> [a] -> ([a], [a])
exchange n xs ys =
  let [xs_, ys_] = splitAt n <$> [xs, ys]
  in (fst ys_ <> snd xs_, fst xs_ <> snd ys_)

-- SHUFFLE -----------------------------------------------
-- (See Knuth Shuffle task)
knuthShuffle :: [a] -> IO [a]
knuthShuffle xs = (foldr swapElems xs . zip [1 ..]) <$> randoms (length xs)

randoms :: Int -> IO [Int]
randoms x = traverse (randomRIO . (,) 0) [1 .. (pred x)]

swapElems :: (Int, Int) -> [a] -> [a]
swapElems (i, j) xs
  | i == j = xs
  | otherwise = replaceAt j (xs !! i) $ replaceAt i (xs !! j) xs

replaceAt :: Int -> a -> [a] -> [a]
replaceAt i c l =
  let (a, b) = splitAt i l
  in a ++ c : drop 1 b
