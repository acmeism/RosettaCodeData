import Text.Printf (printf)

--- SMALLEST INTEGER EVENLY DIVISIBLE BY EACH OF [1..N] --

smallest :: Integer -> Integer
smallest =
  foldr lcm 1 . enumFromTo 1


--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    showSmallest <$> [10, 20, 200, 2000]

------------------------- DISPLAY ------------------------
showSmallest :: Integer -> String
showSmallest =
  ((<>) . (<> " -> ") . printf "%4d")
    <*> (printf "%d" . smallest)
