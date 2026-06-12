import Data.List (sortOn)

main :: IO ()
main =
  mapM_ print $
    sortOn
      length
      [ "Rosetta",
        "code",
        "is",
        "a",
        "programming",
        "chrestomathy",
        "site"
      ]
