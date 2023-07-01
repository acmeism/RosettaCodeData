import Data.Char (digitToInt, intToDigit, isHexDigit)
import Data.List (transpose)
import Numeric (readInt, showIntAtBase)

------------------ SUM OF INTEGER DIGITS -----------------

digitSum :: String -> Int
digitSum = foldr ((+) . digitToInt) 0

intDigitSum :: Int -> Int -> Int
intDigitSum base =
  digitSum
    . flip (showIntAtBase base intToDigit) []


-------------------------- TESTS -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    unwords
      <$> transpose
        ( ( fmap
              =<< flip justifyRight ' '
                . succ
                . maximum
                . fmap length
          )
            <$> transpose
              ( [ "Base",
                  "Digits",
                  "Value",
                  "digit string -> sum",
                  "integer value -> sum"
                ] :
                ( ( \(s, b) ->
                      let v = readBase b s
                       in [ show b, -- base
                            show s, -- digits
                            show v, -- value
                            -- sum from digit string
                            show (digitSum s),
                            -- sum from base and value
                            show (intDigitSum b v)
                          ]
                  )
                    <$> [ ("1", 10),
                          ("1234", 10),
                          ("fe", 16),
                          ("f0e", 16)
                        ]
                )
              )
        )
  where
    justifyRight n c = (drop . length) <*> (replicate n c <>)
    readBase b s = n
      where
        [(n, _)] = readInt b isHexDigit digitToInt s
