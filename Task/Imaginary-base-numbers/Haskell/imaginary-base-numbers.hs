import Data.Char (chr, digitToInt, intToDigit, isDigit, ord)
import Data.Complex (Complex (..), imagPart, realPart)
import Data.List (delete, elemIndex)
import Data.Maybe (fromMaybe)

base :: Complex Float
base = 0 :+ 2

quotRemPositive :: Int -> Int -> (Int, Int)
quotRemPositive a b
  | r < 0 = (1 + q, floor (realPart (-base ^^ 2)) + r)
  | otherwise = (q, r)
  where
    (q, r) = quotRem a b

digitToIntQI :: Char -> Int
digitToIntQI c
  | isDigit c = digitToInt c
  | otherwise = ord c - ord 'a' + 10

shiftRight :: String -> String
shiftRight n
  | l == '0' = h
  | otherwise = h <> ('.' : [l])
  where
    (l, h) = (last n, init n)

intToDigitQI :: Int -> Char
intToDigitQI i
  | i `elem` [0 .. 9] = intToDigit i
  | otherwise = chr (i - 10 + ord 'a')

fromQItoComplex :: String -> Complex Float -> Complex Float
fromQItoComplex num b =
  let dot = fromMaybe (length num) (elemIndex '.' num)
   in fst $
        foldl
          ( \(a, indx) x ->
              ( a + fromIntegral (digitToIntQI x)
                  * (b ^^ (dot - indx)),
                indx + 1
              )
          )
          (0, 1)
          (delete '.' num)

euclidEr :: Int -> Int -> [Int] -> [Int]
euclidEr a b l
  | a == 0 = l
  | otherwise =
      let (q, r) = quotRemPositive a b
       in euclidEr q b (0 : r : l)

fromIntToQI :: Int -> [Int]
fromIntToQI 0 = [0]
fromIntToQI x =
  tail
    ( euclidEr
        x
        (floor $ realPart (base ^^ 2))
        []
    )

getCuid :: Complex Int -> Int
getCuid c = imagPart c * floor (imagPart (-base))

qizip :: Complex Int -> [Int]
qizip c =
  let (r, i) =
        ( fromIntToQI (realPart c) <> [0],
          fromIntToQI (getCuid c)
        )
   in let m = min (length r) (length i)
       in take (length r - m) r
            <> take (length i - m) i
            <> reverse
              ( zipWith
                  (+)
                  (take m (reverse r))
                  (take m (reverse i))
              )

fromComplexToQI :: Complex Int -> String
fromComplexToQI = shiftRight . fmap intToDigitQI . qizip

main :: IO ()
main =
  putStrLn (fromComplexToQI (35 :+ 23))
    >> print (fromQItoComplex "10.2" base)
