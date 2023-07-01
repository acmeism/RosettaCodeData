import Numeric (showOct)

main :: IO ()
main =
  mapM_
    (putStrLn . flip showOct "")
    [1 .. maxBound :: Int]
