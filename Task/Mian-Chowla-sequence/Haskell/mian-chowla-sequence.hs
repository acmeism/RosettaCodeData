import Data.Set (Set, fromList, insert, member)

------------------- MIAN-CHOWLA SEQUENCE -----------------
mianChowlas :: Int -> [Int]
mianChowlas =
  reverse . snd . (iterate nextMC (fromList [2], [1]) !!) . subtract 1

nextMC :: (Set Int, [Int]) -> (Set Int, [Int])
nextMC (sumSet, mcs@(n:_)) =
  (foldr insert sumSet ((2 * m) : fmap (m +) mcs), m : mcs)
  where
    valid x = not $ any (flip member sumSet . (x +)) mcs
    m = until valid succ n

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines)
    [ "First 30 terms of the Mian-Chowla series:"
    , show (mianChowlas 30)
    , []
    , "Terms 91 to 100 of the Mian-Chowla series:"
    , show $ drop 90 (mianChowlas 100)
    ]
