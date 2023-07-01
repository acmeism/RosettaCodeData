module Main
  where

main = printMersennes $ take 45 $ filter lucasLehmer $ sieve [2..]

s mp 1 = 4 `mod` mp
s mp n = ((s mp $ n-1)^2-2) `mod` mp

lucasLehmer 2 = True
lucasLehmer p = s (2^p-1) (p-1) == 0

printMersennes = mapM_ (\x -> putStrLn $ "M" ++ show x)
