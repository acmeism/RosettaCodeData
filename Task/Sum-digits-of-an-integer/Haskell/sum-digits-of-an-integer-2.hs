import Data.Char (digitToInt, intToDigit, isHexDigit)
import Data.List (transpose, intersperse)
import Numeric (showIntAtBase, readInt)

-- Function of digit string
digitSum :: String -> Int
digitSum = sum . (digitToInt <$>)

-- Function of base and integer value
intDigitSum :: Int -> Int -> Int
intDigitSum base n = digitSum (showIntAtBase base intToDigit n [])

-- TEST
main :: IO ()
main =
  mapM_ putStrLn $
  unwords <$>
  transpose
    (((<$>) =<< flip justifyRight ' ' . succ . maximum . (length <$>)) <$>
     transpose
       ([ "Base"
        , "Digits"
        , "Value"
        , "digit string -> sum"
        , "integer value -> sum"
        ] :
        ((\(s, b) ->
             let v = readBase b s
             in [ show b                 -- base
                , show s                 -- digits
                , show v                 -- value
                , show (digitSum s)      -- sum from digit string
                , show (intDigitSum b v) -- sum from base and value
                ]) <$>
         [("1", 10), ("1234", 10), ("fe", 16), ("f0e", 16)])))
  where
    justifyRight n c s = drop (length s) (replicate n c ++ s)
    readBase b s =
      let [(n, _)] = readInt b isHexDigit digitToInt s
      in n
