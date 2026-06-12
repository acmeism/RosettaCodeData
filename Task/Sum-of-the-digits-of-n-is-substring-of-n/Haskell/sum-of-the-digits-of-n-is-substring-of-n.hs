import Data.Char (digitToInt)
import Data.List (isInfixOf)
import Data.List.Split (chunksOf)

-------- SUM OF THE DIGITS OF N IS A SUBSTRING OF N ------

digitSumIsSubString :: String -> Bool
digitSumIsSubString =
  isInfixOf
    =<< show . foldr ((+) . digitToInt) 0


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    showMatches digitSumIsSubString <$> [999, 10000]

showMatches :: (String -> Bool) -> Int -> String
showMatches p limit =
  ( show (length xs)
      <> " matches in [0.."
      <> show limit
      <> "]\n"
  )
    <> unlines
      ( unwords
          <$> chunksOf 10 (justifyRight w ' ' <$> xs)
      )
    <> "\n"
  where
    xs = filter p $ fmap show [0 .. limit]
    w = length (last xs)

justifyRight :: Int -> Char -> String -> String
justifyRight n c = (drop . length) <*> (replicate n c <>)
