import Data.Matrix

main :: IO ()
main = print matrix >> print (transpose matrix)
  where
    matrix = fromList 3 4 [1 ..]
