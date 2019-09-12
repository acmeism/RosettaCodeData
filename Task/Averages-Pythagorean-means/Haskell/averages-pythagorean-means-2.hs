import Control.Applicative (liftA2)
import Data.List (genericLength)

-- ARITHMETIC, GEOMETRIC AND HARMONIC MEANS ---------------

arithmetic, geometric, harmonic :: [Double] -> Double
arithmetic = liftA2 (/) sum genericLength

geometric = liftA2 (**) product ((1 /) . genericLength)

harmonic = liftA2 (/) genericLength (foldr ((+) . (1 /)) 0)

-- TEST ---------------------------------------------------
xs :: [Double]
xs = [arithmetic, geometric, harmonic] <*> [[1 .. 10]]

main :: IO ()
main =
  (putStrLn . unlines)
    [ zip ["Arithmetic", "Geometric", "Harmonic"] xs >>= show
    , mappend "\n A >= G >= H is " $ --
      (show . and) $ zipWith (>=) xs (tail xs)
    ]
