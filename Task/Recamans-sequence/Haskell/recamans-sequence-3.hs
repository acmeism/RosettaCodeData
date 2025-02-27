import Data.Set (Set, fromList, insert, isSubsetOf, member, size)
import Data.Bool (bool)

firstNRecamans :: Int -> [Int]
firstNRecamans n = reverse $ recamanUpto (\(_, i, _) -> n == i)

firstDuplicateR :: Int
firstDuplicateR = head $ recamanUpto (\(rs, _, set) -> size set /= length rs)

recamanSuperset :: Set Int -> [Int]
recamanSuperset setInts =
  tail $ recamanUpto (\(_, _, setR) -> isSubsetOf setInts setR)

recamanUpto :: (([Int], Int, Set Int) -> Bool) -> [Int]
recamanUpto p = rs
  where
    (rs, _, _) =
      until
        p
        (\(rs@(r:_), i, seen) ->
            let n = nextR seen i r
            in (n : rs, succ i, insert n seen))
        ([0], 1, fromList [0])

nextR :: Set Int -> Int -> Int -> Int
nextR seen i r =
  let back = r - i
  in bool back (r + i) (0 > back || member back seen)

-- TEST ---------------------------------------------------------------
main :: IO ()
main =
  (putStrLn . unlines)
    [ "First 15 Recamans:"
    , show $ firstNRecamans 15
    , []
    , "First duplicated Recaman:"
    , show firstDuplicateR
    , []
    , "Length of Recaman series required to include [0..1000]:"
    , (show . length . recamanSuperset) $ fromList [0 .. 1000]
    ]
