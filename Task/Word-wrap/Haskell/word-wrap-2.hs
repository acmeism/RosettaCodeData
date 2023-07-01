import Data.List (inits, tail, tails)

wWrap :: Int -> String -> String
wWrap n =
  unlines
    . map unwords
    . wWrap'' n
    . words
    . concat
    . lines

wWrap'' :: Int -> [String] -> [[String]]
wWrap'' _ [] = []
wWrap'' n ss =
  (\(a, b) -> a : wWrap'' n b) $
    last . filter ((<= n) . length . unwords . fst) $
      zip (inits ss) (tails ss)


main :: IO ()
main =
  putStrLn $
    wWrap 80 $
      concat
        [ "In olden times when wishing still helped one,",
          " there lived a king whose daughters were all",
          " beautiful, but the youngest was so beautiful",
          " that the sun itself, which has seen so much,",
          " was astonished whenever, it shone in her",
          " face.  Close by the king's castle lay a great",
          " dark forest, and under an old lime-tree in",
          " the forest was a well, and when the day was",
          " very warm, the king's child went out into the",
          " forest and sat down by the side of the cool",
          " fountain, and when she was bored she took a",
          " golden ball, and threw it up on high and",
          " caught it, and this ball was her favorite",
          " plaything."
        ]
