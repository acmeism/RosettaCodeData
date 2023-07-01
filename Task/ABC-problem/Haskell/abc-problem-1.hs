import Data.List (delete)
import Data.Char (toUpper)

-- returns list of all solutions, each solution being a list of blocks
abc :: (Eq a) => [[a]] -> [a] -> [[[a]]]
abc _ [] = [[]]
abc blocks (c:cs) = [b:ans | b <- blocks, c `elem` b,
                             ans <- abc (delete b blocks) cs]

blocks = ["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
          "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"]

main :: IO ()
main = mapM_ (\w -> print (w, not . null $ abc blocks (map toUpper w)))
         ["", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"]
