import Data.Function (on)
import Data.List (groupBy, intercalate, sort, sortOn)
import Data.Ord (comparing)

main :: IO ()
main =
  readFile "mitWords.txt"
    >>= ( putStrLn
            . unlines
            . fmap (intercalate " -> ")
            . (circularOnly =<<)
            . anagrams
            . lines
        )

anagrams :: [String] -> [[String]]
anagrams ws =
  let harvest group px
        | px = [fmap snd group]
        | otherwise = []
   in groupBy
        (on (==) fst)
        (sortOn fst (((,) =<< sort) <$> ws))
        >>= (harvest <*> ((> 2) . length))

circularOnly :: [String] -> [[String]]
circularOnly ws
  | (length h - 1) > length rs = []
  | otherwise = [h : rs]
  where
    h = head ws
    rs = filter (isRotation h) (tail ws)

isRotation :: String -> String -> Bool
isRotation xs ys =
  xs
    /= until
      ( (||)
          . (ys ==)
          <*> (xs ==)
      )
      rotated
      (rotated xs)

rotated :: [a] -> [a]
rotated [] = []
rotated (x : xs) = xs <> [x]
