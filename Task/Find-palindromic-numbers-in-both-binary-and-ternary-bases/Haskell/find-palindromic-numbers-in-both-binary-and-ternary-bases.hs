import Data.Char (digitToInt, intToDigit, isDigit)
import Data.List (transpose, unwords)
import Numeric (readInt, showIntAtBase)

---------- PALINDROMIC IN BOTH BINARY AND TERNARY --------

dualPalindromics :: [Integer]
dualPalindromics =
  0 :
  1 :
  take
    4
    ( filter
        isBinPal
        (readBase3 . base3Palindrome <$> [1 ..])
    )

base3Palindrome :: Integer -> String
base3Palindrome =
  ((<>) <*> (('1' :) . reverse)) . showBase 3

isBinPal :: Integer -> Bool
isBinPal n =
  ( \s ->
      ( \(q, r) ->
          (1 == r)
            && drop (succ q) s == reverse (take q s)
      )
        $ quotRem (length s) 2
  )
    $ showBase 2 n

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    ( unwords
        <$> transpose
          ( ( fmap
                =<< flip justifyLeft ' '
                  . succ
                  . maximum
                  . fmap length
            )
              <$> transpose
                ( ["Decimal", "Ternary", "Binary"] :
                  fmap
                    ( (<*>) [show, showBase 3, showBase 2]
                        . return
                    )
                    dualPalindromics
                )
          )
    )
  where
    justifyLeft n c s = take n (s <> replicate n c)

-------------------------- BASES -------------------------

readBase3 :: String -> Integer
readBase3 = fst . head . readInt 3 isDigit digitToInt

showBase :: Integer -> Integer -> String
showBase base n = showIntAtBase base intToDigit n []
