import Data.List (isInfixOf)
import Data.Char (intToDigit)

isSuperd :: (Show a, Integral a) => a -> a -> Bool
isSuperd p n =
  (replicate <*> intToDigit) (fromIntegral p) `isInfixOf` show (p * n ^ p)

findSuperd :: (Show a, Integral a) => a -> [a]
findSuperd p = filter (isSuperd p) [1 ..]

main :: IO ()
main =
  mapM_
    (putStrLn .
     ("First 10 super-" ++) .
     ((++) . show <*> ((" : " ++) . show . take 10 . findSuperd)))
    [2 .. 6]
