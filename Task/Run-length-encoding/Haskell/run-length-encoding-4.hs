----------------------- RUN LENGTHS ----------------------

runLengths :: String -> [(Int, Char)]
runLengths "" = []
runLengths s = uncurry (:) (foldr go ((0, ' '), []) s)
  where
    go c ((0, _), xs) = ((1, c), xs)
    go c ((n, x), xs)
      | c == x = ((succ n, x), xs)
      | otherwise = ((1, c), (n, x) : xs)

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let testString =
        "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWW"
          <> "WWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
      encoded = runLengths testString
  putStrLn $ showLengths encoded
  print $
    concatMap (uncurry replicate) encoded == testString

------------------------- DISPLAY ------------------------
showLengths :: [(Int, Char)] -> String
showLengths [] = []
showLengths ((n, c) : xs) = show n <> [c] <> showLengths xs
