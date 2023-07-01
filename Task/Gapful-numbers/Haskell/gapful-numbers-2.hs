import Data.List (intercalate)
import Data.List.Split (chunksOf)

---------------------- GAPFUL NUMBERS --------------------

isGapful :: Int -> Bool
isGapful =
  (0 ==)
    . (<*>)
      rem
      (read . (<*>) [head, last] . pure . show)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . showSample)
    [ "First 30 gapful numbers >= 100",
      "First 15 Gapful numbers >= 1000000",
      "First 10 Gapful numbers >= 1000000000"
    ]

showSample :: String -> String
showSample k =
  let ws = words k
   in k <> ":\n\n"
        <> unlines
          ( fmap (intercalate ", " . fmap show) $
              chunksOf 5 $
                take
                  (read (ws !! 1))
                  [read (ws !! 5) :: Int ..]
          )
