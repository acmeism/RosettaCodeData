import Data.List (inits, intercalate, transpose)
import Data.Bool (bool)

-- REP-CYCLES ---------------------------------------------
repCycles :: String -> [String]
repCycles cs =
  let n = length cs
  in filter ((cs ==) . take n . cycle) (tail $ inits (take (quot n 2) cs))

-- TEST ---------------------------------------------------
main :: IO ()
main =
  putStrLn $
  fTable
    "Longest cycles:\n"
    id
    ((flip bool "n/a" . last) <*> null)
    repCycles
    [ "1001110011"
    , "1110111011"
    , "0010010010"
    , "1010101010"
    , "1111111111"
    , "0100101101"
    , "0100100"
    , "101"
    , "11"
    , "00"
    , "1"
    ]

-- GENERIC ------------------------------------------------
fTable :: String -> (a -> String) -> (b -> String) -> (a -> b) -> [a] -> String
fTable s xShow fxShow f xs =
  let rjust n c = drop . length <*> (replicate n c ++)
      w = maximum (length . xShow <$> xs)
  in unlines $
     s : fmap (((++) . rjust w ' ' . xShow) <*> ((" -> " ++) . fxShow . f)) xs
