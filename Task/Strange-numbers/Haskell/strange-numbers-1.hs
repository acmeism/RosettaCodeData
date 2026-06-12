import Data.List (intercalate)
import Data.List.Split (chunksOf)

--------------------- STRANGE NUMBERS --------------------

isStrange :: Int -> Bool
isStrange n =
  all
    (\(a, b) -> abs (a - b) `elem` [2, 3, 5, 7])
    $ (zip <*> tail) (digits n)

digits :: Int -> [Int]
digits = fmap (read . return) . show

--------------------------- TEST -------------------------
main =
  let xs = filter isStrange [100 .. 500]
   in (putStrLn . intercalate "\n\n")
        [ "Strange numbers found in range [100..500]",
          "(total " <> (show . length) xs <> ")",
          "Full list:",
          unlines
            (unwords <$> chunksOf 10 (show <$> xs))
        ]
