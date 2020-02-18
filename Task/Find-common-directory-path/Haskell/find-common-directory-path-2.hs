import Data.List (transpose, intercalate)
import Data.List.Split (splitOn)
import Data.Bool (bool)

cdp :: [String] -> String
cdp =
  flip
    (bool .
     intercalate "/" .
     fmap head .
     takeWhile ((all . (==) . head) <*> tail) . transpose . fmap (splitOn "/"))
    ([]) <*>
  null

main :: IO ()
main =
  (putStrLn . cdp)
    [ "/home/user1/tmp/coverage/test"
    , "/home/user1/tmp/covert/operator"
    , "/home/user1/tmp/coven/members"
    ]
