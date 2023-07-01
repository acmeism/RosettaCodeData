import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.Ix (range)
import Data.List.Split (chunksOf)
import Data.Tuple (swap)

---------------------- PASCAL MATRIX ---------------------

pascalMatrix :: ((Int, Int) -> (Int, Int)) -> Int -> [Int]
pascalMatrix f n =
  bc . f
    <$> range
      ((0, 0), join bimap pred (n, n))

-- Binomial coefficient
bc :: (Int, Int) -> Int
bc (n, k) =
  foldr
    (\x a -> quot (a * succ (n - x)) x)
    1
    [k, pred k .. 1]


--------------------------- TEST -------------------------
matrixSize = 5 :: Int

main :: IO ()
main =
  mapM_
    putStrLn
    ( unlines
        . ( \(s, xs) ->
              s :
              (show <$> chunksOf matrixSize xs)
          )
        <$> zip
          ["Lower", "Upper", "Symmetric"]
          ( pascalMatrix
              <$> [ id, -- Lower
                    swap, -- Upper
                    \(a, b) -> (a + b, b) -- Symmetric
                  ]
              <*> [matrixSize]
          )
    )
