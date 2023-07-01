main :: IO ()
main = putStr . unlines . (!!3) $ iterate next ["#"]

next :: [String] -> [String]
next block =
    block ! block  ! block
              ++
    block ! center ! block
              ++
    block ! block  ! block
    where
      (!)    = zipWith (++)
      center = map (map $ const ' ') block
