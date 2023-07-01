import Data.List

determinant::(Fractional a, Ord a) => [[a]] -> a
determinant ls = if null ls then 0 else pivot 1 (zip ls [(0::Int)..])
  where
  good rs ts = (abs.head.fst $ ts) <= (abs.head.fst $ rs)
  go us (vs,i) = if v == 0 then (ws,i) else (zipWith (\x y -> y - x*v) us ws,i)
    where (v,ws) = (head $ vs,tail vs)
  change i (ys:zs) = map (\xs -> if (==i).snd $ xs then ys else xs) zs
  pivot d [] = d
  pivot d zs@((_,j):ys) = if 0 == u then 0 else pivot e ws
    where
    e = if i == j then u*d else -u*d
    ((u:us),i) = foldl1 (\rs ts ->  if good rs ts then rs else ts) zs
    ws = map (go (map (/u) us)) $ if i == j then ys else change i zs

solveCramer::(Fractional a, Ord a) => [[a]] -> [[a]] -> [[a]]
solveCramer as bs = if 0 == d then [] else ans bs
  where
  d = determinant as
  ans = transpose.map go.transpose
    where
    ms = zip [0..] (transpose as)
    go us =  [ (/d) $ determinant [if i /= j then vs else us | (j,vs) <- ms] | (i,_) <- ms]

matI::(Num a) => Int -> [[a]]
matI n = [ [fromIntegral.fromEnum $ i == j | i <- [1..n]] | j <- [1..n]]

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs). zipWith (\vs u -> map (u*) vs) vss) uss

task::[[Rational]] -> [[Rational]] -> IO()
task a b = do
  let x         = solveCramer a b
  let u         = map (map fromRational) x
  let y         = mult a x
  let identity  = matI (length x)
  let a1        = solveCramer a identity
  let h         = mult a a1
  let z         = mult a1 b
  putStrLn "a ="
  mapM_ print a
  putStrLn "b ="
  mapM_ print b
  putStrLn "solve: a * x = b => x = solveCramer a b ="
  mapM_ print x
  putStrLn "u = fromRationaltoDouble x ="
  mapM_ print u
  putStrLn "verification: y = a * x = mult a x ="
  mapM_ print y
  putStrLn $ "test: y == b = "
  print $ y == b
  putStrLn "identity matrix: identity ="
  mapM_ print identity
  putStrLn "find: a1 = inv(a) => solve: a * a1 = identity => a1 = solveCramer a identity ="
  mapM_ print a1
  putStrLn "verification: h = a * a1 = mult a a1 ="
  mapM_ print h
  putStrLn $ "test: h == identity = "
  print $ h == identity
  putStrLn "z = a1 * b = mult a1 b ="
  mapM_ print z
  putStrLn "test: z == x ="
  print $ z == x

main = do
  let a  = [[2,-1, 5, 1]
           ,[3, 2, 2,-6]
           ,[1, 3, 3,-1]
           ,[5,-2,-3, 3]]
  let b  = [[-3], [-32], [-47], [49]]
  task a b
