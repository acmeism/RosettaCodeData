module Main where

------------------------
--  ENCODER FUNCTION  --
------------------------

romanDigits = "IVXLCDM"

--  Meaning and indices of the romanDigits sequence:
--
--    magnitude |  1 5  | index
--   -----------|-------|-------
--        0     |  I V  |  0 1
--        1     |  X L  |  2 3
--        2     |  C D  |  4 5
--        3     |  M    |  6
--
--  romanPatterns are index offsets into romanDigits,
--  from an index base of 2 * magnitude.

romanPattern 0 = []      -- empty string
romanPattern 1 = [0]     -- I or X or C or M
romanPattern 2 = [0,0]   -- II or XX...
romanPattern 3 = [0,0,0] -- III...
romanPattern 4 = [0,1]   -- IV...
romanPattern 5 = [1]     -- ...
romanPattern 6 = [1,0]
romanPattern 7 = [1,0,0]
romanPattern 8 = [1,0,0,0]
romanPattern 9 = [0,2]

encodeValue 0 _ = ""
encodeValue value magnitude = encodeValue rest (magnitude + 1) ++ digits
  where
    low = rem value 10 -- least significant digit (encoded now)
    rest = div value 10 -- the other digits (to be encoded next)
    indices = map addBase (romanPattern low)
    addBase i = i + (2 * magnitude)
    digits = map pickDigit indices
    pickDigit i = romanDigits!!i

encode value = encodeValue value 0

------------------
--  TEST SUITE  --
------------------

main = do
  test "MCMXC" 1990
  test "MMVIII" 2008
  test "MDCLXVI" 1666

test expected value = putStrLn ((show value) ++ " = " ++ roman ++ remark)
  where
    roman = encode value
    remark =
      " (" ++
      (if roman == expected then "PASS"
       else ("FAIL, expected " ++ (show expected))) ++ ")"
