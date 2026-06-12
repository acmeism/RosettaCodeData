import Data.List (sortOn)

main :: IO ()
main =
  mapM_ print $
    sortOn
      snd
      [ ("Rosetta", 7),
        ("Code", 4),
        ("is", 2),
        ("a", 1),
        ("programming", 11),
        ("chrestomathy", 12),
        ("site", 4)
      ]
