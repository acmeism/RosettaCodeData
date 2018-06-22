import Data.List (unfoldr)
import Data.Tuple (swap)

isPernicious :: Int -> Bool
isPernicious = isPrime . popCount

popCount :: Int -> Int
popCount =
  sum . unfoldr ((flip if_ Nothing . (0 ==)) <*> (Just . swap . flip quotRem 2))

isPrime :: Int -> Bool
isPrime =
  (==) <$> (\n -> [1 .. n] >>= flip ((if_ . (0 ==) . mod n) <*> return) []) <*>
  ((1 :) . return)

if_ :: Bool -> a -> a -> a
if_ True x _ = x
if_ False _ y = y

main :: IO ()
main =
  mapM_
    print
    [ take 25 $ filter isPernicious [1 ..]
    , filter isPernicious [888888877 .. 888888888]
    ]
