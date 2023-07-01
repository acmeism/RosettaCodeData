import Data.List (intercalate)
import Data.Bool (bool)

charGroups :: String -> [String]
charGroups =
  let go (a, b) (s, groups)
        | a == b = (b : s, groups)
        | otherwise =
            ( [a],
              bool s [b] (null s) : groups
            )
   in uncurry (:) . foldr go ([], []) . (zip <*> tail)

main :: IO ()
main =
  putStrLn $ intercalate ", " $ charGroups "gHHH5YY++///\\"
