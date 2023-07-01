import Data.Set (Set, fromList, member)

gaps :: [Int]
gaps = dropWhile (`member` mcNuggets) [100,99 .. 1]

mcNuggets :: Set Int
mcNuggets =
  let size n = [0 .. quot 100 n]
  in fromList
       [ v
       | x <- size 6
       , y <- size 9
       , z <- size 20
       , let v = sum [6 * x, 9 * y, 20 * z]
       , 101 > v ]

main :: IO ()
main =
  print $
  case gaps of
    x:_ -> show x
    []  -> "No unreachable quantities found ..."
