import Data.List (intercalate)
import Data.List.Split (chunksOf)

------------------- STRANGE PLUS NUMBERS -----------------

isStrangePlus :: Int -> Bool
isStrangePlus n =
  all
    (\(a, b) -> (a + b) `elem` [2, 3, 5, 7, 11, 13, 17])
    $ (zip <*> tail) (digits n)


digits :: Int -> [Int]
digits = fmap (read . return) . show

--------------------------- TEST -------------------------
main =
  let xs = filter isStrangePlus [100 .. 500]
   in (putStrLn . intercalate "\n\n")
        [ "\"Strange Plus\" numbers found in range [100..500]",
          "(total " <> (show . length) xs <> ")",
          "Full list:",
          unlines
            (unwords <$> chunksOf 10 (show <$> xs))
        ]
