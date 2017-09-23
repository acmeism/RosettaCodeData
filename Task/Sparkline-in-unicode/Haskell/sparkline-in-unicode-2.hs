import Data.List.Split (splitOneOf)

sparkLine :: [Float] -> String
sparkLine xs =
  (("▁▂▃▄▅▆▇█" !!) . floor . (/ range) . (7 *) . subtract min) <$> xs
  where
    min = minimum xs
    range = maximum xs - min

parseFloats :: String -> [Float]
parseFloats = (read <$>) . filter (not . null) . splitOneOf " ,"

main :: IO ()
main =
  mapM_
    putStrLn
    ((sparkLine . parseFloats) <$>
     [ "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1"
     , "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
     , "3 2 1 0 -1 -2 -3 -4 -3 -2 -1 0 1 2 3"
     , "-1000 100 1000 500 200 -400 -700 621 -189 3"
     ])
