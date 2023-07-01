import Text.Printf (printf)

input :: [(String, Char)]
input = [ ("", ' ')
        , ("The better the 4-wheel drive, the further you'll be from help when ya get stuck!", 'e')
        , ("headmistressship", 's')
        , ("\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ", '-')
        , ("..1111111111111111111111111111111111111111111111111111111111111117777888", '7')
        , ("I never give 'em hell, I just tell the truth, and they think it's hell. ", '.')
        , ("                                                    --- Harry S Truman  ", 'r')
        , ("aardvark", 'a')
        , ("😍😀🙌💃😍😍😍🙌", '😍')
        ]

collapse :: Eq a => [a] -> a -> [a]
collapse s c = go s
  where go [] = []
        go (x:y:xs)
          | x == y && x == c = go (y:xs)
          | otherwise        = x : go (y:xs)
        go xs = xs

main :: IO ()
main =
  mapM_ (\(a, b, c) -> printf "squeeze: '%c'\nold: %3d «««%s»»»\nnew: %3d «««%s»»»\n\n" c (length a) a (length b) b)
  $ (\(s, c) -> (s, collapse s c, c)) <$> input
