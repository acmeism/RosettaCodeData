import Data.Char (chr)
import Data.List.Split (splitOn)

deCode :: String -> String
deCode url =
  let ps = splitOn "%" url
  in concat $
     head ps :
     ((\(a, b) -> (chr . read) (mappend "0x" a) : b) <$> (splitAt 2 <$> tail ps))

-- TEST ------------------------------------------------------------------------
main :: IO ()
main = putStrLn $ deCode "http%3A%2F%2Ffoo%20bar%2F"
