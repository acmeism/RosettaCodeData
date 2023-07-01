import Data.Char

sentence = start ++ foldMap add (zip [2..] $ tail $ words sentence)
  where
    start = "Four is the number of letters in the first word of this sentence, "
    add (i, w) = unwords [spellInteger (alphaLength w), "in the", spellOrdinal i ++ ", "]

alphaLength w = fromIntegral $ length $ filter isAlpha w

main = mapM_ (putStrLn . say) [1000,10000,100000,1000000]
  where
    ws = words sentence
    say n =
      let (a, w:_) = splitAt (n-1) ws
      in "The " ++ spellOrdinal n ++ " word is \"" ++ w ++ "\" which has " ++
         spellInteger (alphaLength  w) ++ " letters. The sentence length is " ++
         show (length $ unwords a) ++ " chars."
