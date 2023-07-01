import Data.List (intercalate)

quibble :: [String] -> String
quibble ws
  | length ws > 1 =
    intercalate
      " and "
      ([intercalate ", " . reverse . tail, head] <*> [reverse ws])
  | otherwise = concat ws

main :: IO ()
main =
  mapM_ (putStrLn . (`intercalate` ["{", "}"]) . quibble) $
  [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]] ++
  (words <$> ["One two three four", "Me myself I", "Jack Jill", "Loner"])
