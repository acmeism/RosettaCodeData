run n = findIndices odd $ foldr toggleEvery (replicate n 0) [0..n] where toggleEvery k =  zipWith (+) $ cycle $ 1 : replicate k 0
