import Data.Array.IArray
import Cholesky

ex1, ex2 :: Arr
ex1 = listArray ((0,0),(2,2)) [25, 15, -5,
                               15, 18,  0,
                               -5,  0, 11]

ex2 = listArray ((0,0),(3,3)) [18, 22,  54,  42,
                               22, 70,  86,  62,
                               54, 86, 174, 134,
                               42, 62, 134, 106]

main :: IO ()
main = do
  print $ elems $ cholesky ex1
  print $ elems $ cholesky ex2
