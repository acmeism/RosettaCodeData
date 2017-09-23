pytr :: Int -> [(Bool, Int, Int, Int)]
pytr n =
  filter
    (\(_, a, b, c) -> a + b + c <= n)
    [ (prim a b c, a, b, c)
    | a <- xs
    , b <- drop a xs
    , c <- drop b xs
    , a ^ 2 + b ^ 2 == c ^ 2 ]
  where
    xs = [1 .. n]
    prim a b _ = gcd a b == 1

main :: IO ()
main =
  putStrLn $
  "Up to 100 there are " ++
  show (length xs) ++
  " triples, of which " ++
  show (length $ filter (\(x, _, _, _) -> x) xs) ++ " are primitive."
  where
    xs = pytr 100
