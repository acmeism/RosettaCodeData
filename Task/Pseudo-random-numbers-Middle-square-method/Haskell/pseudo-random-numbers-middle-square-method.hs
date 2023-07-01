findPseudoRandom :: Int -> Int
findPseudoRandom seed =
   let square = seed * seed
       squarestr = show square
       enlarged = replicate ( 12 - length squarestr ) '0' ++ squarestr
   in read $ take 6 $ drop 3 enlarged

solution :: [Int]
solution = tail $ take 6 $ iterate findPseudoRandom 675248
