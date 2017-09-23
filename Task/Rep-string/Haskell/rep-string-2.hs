import Data.List (inits, intercalate, transpose)

-- REP-CYCLES -----------------------------------------------------------------
repCycles :: String -> [String]
repCycles cs =
  let n = length cs
  in filter ((cs ==) . take n . cycle) (tail $ inits (take (quot n 2) cs))

cycleReport :: String -> [String]
cycleReport xs =
  let reps = repCycles xs
  in [ xs
     , if not (null reps)
         then last reps
         else "(n/a)"
     ]

-- TEST -----------------------------------------------------------------------
main :: IO ()
main = do
  putStrLn "Longest cycles:\n"
  putStrLn $
    unlines $
    table "  -> " $
    cycleReport <$>
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

-- GENERIC --------------------------------------------------------------------
table :: String -> [[String]] -> [String]
table delim rows =
  intercalate delim <$>
  transpose
    ((\col ->
         let width = (length $ maximum col)
             justifyLeft n c s = take n (s ++ replicate n c)
         in justifyLeft width ' ' <$> col) <$>
     transpose rows)
