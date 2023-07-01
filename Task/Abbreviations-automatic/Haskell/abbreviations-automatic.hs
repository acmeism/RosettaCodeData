import Data.List (inits, intercalate, transpose)
import qualified Data.Set as S

--------------- MINIMUM ABBREVIATION LENGTH --------------

minAbbrevnLength :: [String] -> Int
minAbbrevlnLength [] = 0
minAbbrevnLength xs =
  length . head . S.toList . head $
    dropWhile ((< n) . S.size) $
      S.fromList
        <$> transpose (inits <$> xs)
  where
    n = length xs

--------------------------- TEST -------------------------
main :: IO ()
main = do
  s <- readFile "./weekDayNames.txt"
  mapM_ putStrLn $
    take 10 $
      intercalate "\t"
        . (<*>)
          [ show . minAbbrevnLength . words,
            id
          ]
        . return
        <$> lines s
