import Data.List (delete)
import Data.Char (toUpper)

-- Any block sequences found
spellWith :: [String] -> String -> [[String]]
spellWith _ [] = [[]]
spellWith blocks (x:xs) =
  foldMap
    (\b ->
        if x `elem` b
          then foldMap (return . (b :)) (spellWith (delete b blocks) xs)
          else [])
    blocks

blocks :: [String]
blocks = words "BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM"

main :: IO ()
main =
  mapM_
    (print . ((,) <*>) (not . null . spellWith blocks . (toUpper <$>)))
    ["", "A", "BARK", "BoOK", "TrEAT", "COmMoN", "SQUAD", "conFUsE"]
