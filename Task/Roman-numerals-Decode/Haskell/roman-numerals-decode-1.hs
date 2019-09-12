module Main where

------------------------
--  DECODER FUNCTION  --
------------------------

decodeDigit :: Char -> Int
decodeDigit 'I' = 1
decodeDigit 'V' = 5
decodeDigit 'X' = 10
decodeDigit 'L' = 50
decodeDigit 'C' = 100
decodeDigit 'D' = 500
decodeDigit 'M' = 1000
decodeDigit _ = error "invalid digit"

--  We process a Roman numeral from right to left, digit by digit, adding the value.
--  If a digit is lower than the previous then its value is negative.
--  The first digit is always positive.

decode roman = decodeRoman startValue startValue rest
  where
    (first:rest) = reverse roman
    startValue = decodeDigit first

decodeRoman :: Int -> Int -> [Char] -> Int
decodeRoman lastSum _ [] = lastSum
decodeRoman lastSum lastValue (digit:rest) = decodeRoman updatedSum digitValue rest
  where
    digitValue = decodeDigit digit
    updatedSum = (if digitValue < lastValue then (-) else (+)) lastSum digitValue

------------------
--  TEST SUITE  --
------------------

main = do
  test "MCMXC" 1990
  test "MMVIII" 2008
  test "MDCLXVI" 1666

test roman expected = putStrLn (roman ++ " = " ++ (show (arabic)) ++ remark)
  where
    arabic = decode roman
    remark = " (" ++ (if arabic == expected then "PASS" else ("FAIL, expected " ++ (show expected))) ++ ")"
