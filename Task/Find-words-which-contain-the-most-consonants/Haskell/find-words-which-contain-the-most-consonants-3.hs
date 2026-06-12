main :: IO ()
main =
  readFile "unixdict.txt"
    >>= mapM_ (mapM_ print)
      . fmap (filter noConsonantTwice)
      . take 1
      . uniqueGlyphCounts consonants
      . lines

noConsonantTwice :: (String, Int) -> Bool
noConsonantTwice =
  uncurry
    ( (==)
        . length
        . filter (`S.member` consonants)
    )
