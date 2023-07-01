import Control.Monad (zipWithM_)
import Data.List (tails)

fiblike :: [Integer] -> [Integer]
fiblike st = xs
  where
    xs = st <> map (sum . take n) (tails xs)
    n = length st

nstep :: Int -> [Integer]
nstep n = fiblike $ take n $ 1 : iterate (2 *) 1

main :: IO ()
main = do
  mapM_ (print . take 10 . fiblike) [[1, 1], [2, 1]]
  zipWithM_
    ( \n name -> do
        putStr (name <> "nacci -> ")
        print $ take 15 $ nstep n
    )
    [2 ..]
    (words "fibo tribo tetra penta hexa hepta octo nona deca")
