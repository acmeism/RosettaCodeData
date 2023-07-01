import Control.Monad (guard)

options :: Int -> Int -> Int -> [(Int, Int, Int)]
options lo hi total =
  let ds = [lo .. hi]
  in do x <- filter even ds
        y <- filter (/= x) ds
        let z = total - (x + y)
        guard $ y /= z && lo <= z && z <= hi
        return (x, y, z)
