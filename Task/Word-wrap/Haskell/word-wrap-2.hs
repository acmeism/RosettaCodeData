import Data.List (inits, tails, tail)

testString =
  concat
    [ "In olden times when wishing still helped one, there lived a king"
    , " whose daughters were all beautiful, but the youngest was so beautiful"
    , " that the sun itself, which has seen so much, was astonished whenever"
    , " it shone in her face.  Close by the king's castle lay a great dark"
    , " forest, and under an old lime-tree in the forest was a well, and when"
    , " the day was very warm, the king's child went out into the forest and"
    , " sat down by the side of the cool fountain, and when she was bored she"
    , " took a golden ball, and threw it up on high and caught it, and this"
    , " ball was her favorite plaything."
    ]

wWrap'' _ [] = []
wWrap'' i ss =
  (\(a, b) -> a : wWrap'' i b) $
  last . filter ((<= i) . length . unwords . fst) $ zip (inits ss) (tails ss)

wWrap :: Int -> String -> String
wWrap i = unlines . map unwords . wWrap'' i . words . concat . lines

main = putStrLn $ wWrap 80 testString
