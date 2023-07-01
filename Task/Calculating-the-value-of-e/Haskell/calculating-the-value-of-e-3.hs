{-# LANGUAGE TupleSections #-}

------------------- APPROXIMATIONS TO E ------------------

approximatEs :: [Double]
approximatEs =
  fst
    <$> iterate
      ( \(e, (i, n)) ->
          (,) . (e +) . (1 /) <*> (succ i,) $ i * n
      )
      (1, (1, 1))

--------------------------- TEST -------------------------
main :: IO ()
main = print $ approximatEs !! 17
