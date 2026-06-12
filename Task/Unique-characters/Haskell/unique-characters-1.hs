import Data.List (group, sort)

uniques :: [String] -> String
uniques ks =
  [c | (c : cs) <- (group . sort . concat) ks, null cs]

main :: IO ()
main =
  putStrLn $
    uniques
      [ "133252abcdeeffd",
        "a6789798st",
        "yxcdfgxcyz"
      ]
