import Data.List (transpose)

lcp :: (Eq a) => [[a]] -> [a]
lcp = fmap head . takeWhile ((all . (==) . head) <*> tail) . transpose

main :: IO ()
main =
  putStrLn
    ( unlines $
        fmap
          showPrefix
          [ ["interspecies", "interstellar", "interstate"],
            ["throne", "throne"],
            ["throne", "dungeon"],
            ["cheese"],
            [""],
            ["prefix", "suffix"],
            ["foo", "foobar"]
          ]
    )
    >> print (lcp ["abc" <> repeat 'd', "abcde" <> repeat 'f'])

showPrefix :: [String] -> String
showPrefix = ((<>) . (<> " -> ") . show) <*> (show . lcp)
