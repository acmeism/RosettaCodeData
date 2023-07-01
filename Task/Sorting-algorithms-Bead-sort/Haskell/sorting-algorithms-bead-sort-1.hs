import Data.List

beadSort :: [Int] -> [Int]
beadSort = map sum. transpose. transpose. map (flip replicate 1)
