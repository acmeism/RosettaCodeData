import Data.Char (isDigit)
import Data.List (span)

encode :: String -> String
encode [] = []
encode (x : xs) =
  let (run, rest) = span (x ==) xs
   in x : (show . succ . length) run <> encode rest

decode :: String -> String
decode [] = []
decode (x : xs) =
  let (ds, rest) = span isDigit xs
      n = read ds :: Int
   in replicate n x <> decode rest

main :: IO ()
main =
  putStrLn encoded
    >> putStrLn decoded
    >> print (src == decoded)
  where
    src = "WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW"
    encoded = encode src
    decoded = decode encoded
