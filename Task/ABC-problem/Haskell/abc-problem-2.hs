import Data.Char (toUpper)
import Data.List (delete)


----------------------- ABC PROBLEM ----------------------

spellWith :: [String] -> String -> [[String]]
spellWith _ [] = [[]]
spellWith blocks (x : xs) = blocks >>= go
  where
    go b
      | x `elem` b = (b :) <$> spellWith (delete b blocks) xs
      | otherwise = []


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    ( print
        . ((,) <*>)
          (not . null . spellWith blocks . fmap toUpper)
    )
    [ "",
      "A",
      "BARK",
      "BoOK",
      "TrEAT",
      "COmMoN",
      "SQUAD",
      "conFUsE"
    ]

blocks :: [String]
blocks =
  words $
    "BO XK DQ CP NA GT RE TG QD FS JW"
      <> " HU VI AN OB ER FS LY PC ZM"
