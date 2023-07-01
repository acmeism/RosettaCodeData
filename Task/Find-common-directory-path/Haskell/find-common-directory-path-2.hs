import Data.List (transpose, intercalate)
import Data.List.Split (splitOn)


------------------ COMMON DIRECTORY PATH -----------------

commonDirectoryPath :: [String] -> String
commonDirectoryPath [] = []
commonDirectoryPath xs =
  intercalate "/" $
  head <$> takeWhile ((all . (==) . head) <*> tail) $
  transpose (splitOn "/" <$> xs)

--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . commonDirectoryPath)
    [ "/home/user1/tmp/coverage/test"
    , "/home/user1/tmp/covert/operator"
    , "/home/user1/tmp/coven/members"
    ]
