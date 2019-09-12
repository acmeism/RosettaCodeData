import Data.List (delete)
import Data.Char (toUpper)

spellWith :: [String] -> String -> [[String]]
spellWith _ [] = [[]]
spellWith blocks (x:xs) =
  let go b
        | x `elem` b = (b :) <$> spellWith (delete b blocks) xs
        | otherwise = []
  in blocks >>= go

blocks :: [String]
blocks = words "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"

main :: IO ()
main =
  mapM_
    (print . ((,) <*>) (not . null . spellWith blocks . fmap toUpper))
    ["", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"]
