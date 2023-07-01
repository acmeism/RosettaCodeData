import Data.Array (Array, Ix, (!), listArray, bounds)

-- BINARY SEARCH USING THE ITERATIVE ALGORITHM
findIndexBinary_
  :: Ord a
  => (a -> Ordering) -> Array Int a -> Either String Int
findIndexBinary_ p axs =
  let (lo, hi) =
        until
          (\(lo, hi) -> lo > hi || 0 == hi)
          (\(lo, hi) ->
              let m = quot (lo + hi) 2
              in case p (axs ! m) of
                   LT -> (lo, pred m)
                   GT -> (succ m, hi)
                   EQ -> (m, 0))
          (bounds axs) :: (Int, Int)
  in if 0 /= hi
       then Left "not found"
       else Right lo

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
  let needle = "kappa"
  in putStrLn $
     '\'' :
     needle ++
     either
       ("' " ++)
       (("' found at index " ++) . show)
       (findIndexBinary_ (compare needle) haystack)
