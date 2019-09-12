import Data.List (transpose, intercalate)
import Data.List.Split (splitOn)

cdp :: [String] -> String
cdp xs
  | null xs = []
  | otherwise =
    (intercalate "/" .
     fmap head . takeWhile same . transpose . fmap (splitOn "/"))
      xs

same
  :: Eq a
  => [a] -> Bool
same [] = True
same (x:xs) = all (x ==) xs

main :: IO ()
main =
  (putStrLn . cdp)
    [ "/home/user1/tmp/coverage/test"
    , "/home/user1/tmp/covert/operator"
    , "/home/user1/tmp/coven/members"
    ]
