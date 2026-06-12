-------------- LONGEST PALINDROMIC SUBSTRINGS ------------

longestPalindromes :: String -> ([String], Int)
longestPalindromes [] = ([], 0)
longestPalindromes s = go $ palindromes s
  where
    go xs
      | null xs = (return <$> s, 1)
      | otherwise = (filter ((w ==) . length) xs, w)
      where
        w = maximum $ length <$> xs

palindromes :: String -> [String]
palindromes = fmap go . palindromicNuclei
  where
    go (pivot, (xs, ys)) =
      let suffix = fmap fst (takeWhile (uncurry (==)) (zip xs ys))
      in reverse suffix <> pivot <> suffix

palindromicNuclei :: String -> [(String, (String, String))]
palindromicNuclei =
  concatMap go .
  init . tail . ((zip . scanl (flip ((<>) . return)) []) <*> scanr (:) [])
  where
    go (a@(x:_), b@(h:y:ys))
      | x == h = [("", (a, b))]
      | otherwise =
        [ ([h], (a, y : ys))
        | x == y ]
    go _ = []


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Longest palindromic substrings:\n"
    show
    show
    longestPalindromes
    [ "three old rotators"
    , "never reverse"
    , "stable was I ere I saw elbatrosses"
    , "abracadabra"
    , "drome"
    , "the abbatial palace"
    , ""
    ]

------------------------ FORMATTING ----------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  unlines $
  s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
  where
    rjust n c = drop . length <*> (replicate n c ++)
    w = maximum (length . xShow <$> xs)
