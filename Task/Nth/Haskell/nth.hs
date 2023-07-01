import Data.Array

ordSuffs :: Array Integer String
ordSuffs = listArray (0,9) ["th", "st", "nd", "rd", "th",
                            "th", "th", "th", "th", "th"]

ordSuff :: Integer -> String
ordSuff n = show n ++ suff n
  where suff m | (m `rem` 100) >= 11 && (m `rem` 100) <= 13 = "th"
               | otherwise          = ordSuffs ! (m `rem` 10)

printOrdSuffs :: [Integer] -> IO ()
printOrdSuffs = putStrLn . unwords . map ordSuff

main :: IO ()
main = do
  printOrdSuffs [   0..  25]
  printOrdSuffs [ 250.. 265]
  printOrdSuffs [1000..1025]
