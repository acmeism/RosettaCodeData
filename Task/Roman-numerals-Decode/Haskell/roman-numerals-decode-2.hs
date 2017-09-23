import Data.List (mapAccumL, isPrefixOf)
import Control.Arrow ((***))

romanValue :: String -> Int
romanValue =
  let tr s (k, v) =
        until (not . isPrefixOf k . fst) (drop (length k) *** (v +)) (s, 0)
  in sum .
     snd .
     flip
       (mapAccumL tr)
       [ ("M", 1000)
       , ("CM", 900)
       , ("D", 500)
       , ("CD", 400)
       , ("C", 100)
       , ("XC", 90)
       , ("L", 50)
       , ("XL", 40)
       , ("X", 10)
       , ("IX", 9)
       , ("V", 5)
       , ("IV", 4)
       , ("I", 1)
       ]

main :: IO ()
main =
  mapM_ (print . romanValue) ["MDCLXVI", "MCMXC", "MMVIII", "MMXVI", "MMXVII"]
