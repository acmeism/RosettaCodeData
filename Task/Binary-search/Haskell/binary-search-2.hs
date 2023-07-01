import Data.Array (Array, Ix, (!), listArray, bounds)

-- BINARY SEARCH USING A HELPER FUNCTION WITH A SIMPLER TYPE SIGNATURE
findIndexBinary
  :: Ord a
  => (a -> Ordering) -> Array Int a -> Either String Int
findIndexBinary p axs =
  let go (lo, hi)
        | hi < lo = Left "not found"
        | otherwise =
          let mid = (lo + hi) `div` 2
          in case p (axs ! mid) of
               LT -> go (lo, pred mid)
               GT -> go (succ mid, hi)
               EQ -> Right mid
  in go (bounds axs)

-- TEST ---------------------------------------------------
haystack :: Array Int String
haystack =
  listArray
    (0, 11)
    [ "alpha"
    , "beta"
    , "delta"
    , "epsilon"
    , "eta"
    , "gamma"
    , "iota"
    , "kappa"
    , "lambda"
    , "mu"
    , "theta"
    , "zeta"
    ]

main :: IO ()
main =
  let needle = "lambda"
  in putStrLn $
     '\'' :
     needle ++
     either
       ("' " ++)
       (("' found at index " ++) . show)
       (findIndexBinary (compare needle) haystack)
