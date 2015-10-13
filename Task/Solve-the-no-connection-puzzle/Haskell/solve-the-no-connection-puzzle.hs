import Data.List

isSolution :: [Int] -> Bool
isSolution (a:b:c:d:e:f:g:h:_) =
        all (\v -> abs v > 1)
        [a-d,
         c-d,
         g-d,
         e-d,

         a-c,
         c-g,
         g-e,
         e-a,

         b-e,
         -- d-e,
         h-e,
         f-e,

         b-d,
         d-h,
         h-f,
         f-b]


main :: IO ()
main = do
      let solution@(a:b:c:d:e:f:g:h:_) = head $ filter isSolution (permutations [1..8])
      mapM_ putStrLn $ zipWith (\label val -> [label] ++ " = " ++ show val)  ['A'..'H'] solution
      putStrLn  ""
      putStrLn  $ "  "            ++ (show a) ++ " " ++ (show b)
      putStrLn  $ (show c) ++ " " ++ (show d) ++ " " ++ (show e) ++ " " ++ (show f)
      putStrLn  $ "  "            ++ (show g) ++ " " ++ (show h)
