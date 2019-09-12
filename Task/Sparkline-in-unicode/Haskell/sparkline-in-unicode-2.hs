import Data.List.Split (splitOneOf)
import Data.List (findIndex)
import Data.Maybe (maybe)
import Control.Arrow ((&&&))

sparkLine :: [Float] -> String
sparkLine xs =
  let (mn, mx) = (minimum &&& maximum) xs
      w = (mx - mn) / 8
      lbounds = ((mn +) . (w *)) <$> [1 .. 7]
  in fmap (maybe '█' ("▁▂▃▄▅▆▇" !!) . flip findIndex lbounds . flip (>)) xs

parseFloats :: String -> [Float]
parseFloats = fmap read . filter (not . null) . splitOneOf " ,"

main :: IO ()
main =
  mapM_
    putStrLn
    ((sparkLine . parseFloats) <$>
     [ "0, 1, 19, 20"
     , "0, 999, 4000, 4999, 7000, 7999"
     , "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1"
     , "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
     ])
