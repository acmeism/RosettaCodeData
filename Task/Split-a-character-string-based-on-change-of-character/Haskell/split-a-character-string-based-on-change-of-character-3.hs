import Data.List (intercalate)

charGroups :: String -> [String]
charGroups [] = []
charGroups (c : cs) =
  let (xs, ys) = span (c ==) cs
   in (c : xs) : charGroups ys

main :: IO ()
main =
  putStrLn $ intercalate ", " $ charGroups "gHHH5YY++///\\"
