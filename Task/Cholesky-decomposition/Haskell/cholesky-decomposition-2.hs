import Data.Array.IArray
import Data.List
import Cholesky

fm _ [] = ""
fm _ [x] = fst x
fm width ((a,b):xs) = a ++ (take (width - b) $ cycle " ") ++ (fm width xs)

fmt width row (xs,[]) = fm width xs
fmt width row (xs,ys) = fm width xs  ++ "\n" ++ fmt width row (splitAt row ys)

showMatrice row xs   = ys where
  vs = map (\s -> let sh = show s in (sh,length sh)) xs
  width = (maximum $ snd $ unzip vs) + 1
  ys = fmt width row (splitAt row vs)

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
  putStrLn $ showMatrice 3 $ elems $ cholesky ex1
  putStrLn $ showMatrice 4 $ elems $ cholesky ex2
