s_permutations :: [a] -> [([a], Int)]
s_permutations = flip zip (cycle [1, -1]) . (foldl aux [[]])
  where aux items x = do
          (f,item) <- zip (cycle [reverse,id]) items
          f (insertEv x item)
        insertEv x [] = [[x]]
        insertEv x l@(y:ys) = (x:l) :  map (y:) (insertEv x ys)

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss = map ((\xs -> if null xs then [] else foldl1 (zipWith (+)) xs). zipWith (\vs u -> map (u*) vs) vss) uss

matI::(Num a) => Int -> [[a]]
matI n = [ [fromIntegral.fromEnum $ i == j | i <- [1..n]] | j <- [1..n]]

elemPos::[[a]] -> Int -> Int -> a
elemPos ms i j = (ms !! i) !! j

prod:: Num a => ([[a]] -> Int -> Int -> a) -> [[a]] -> [Int] -> a
prod f ms = product.zipWith (f ms) [0..]

s_determinant:: Num a => ([[a]] -> Int -> Int -> a) -> [[a]] -> [([Int],Int)] -> a
s_determinant f ms = sum.map (\(is,s) -> fromIntegral s * prod f ms is)

elemCramerPos::Int -> Int -> [[a]] -> [[a]] -> Int -> Int -> a
elemCramerPos l k ks ms i j = if j /= l then elemPos ms i j else elemPos ks i k

solveCramer:: [[Rational]] -> [[Rational]] -> [[Rational]]
solveCramer ms ks = xs
  where
  xs | d /= 0    = go (reverse [0..pred.length.head $ ks])
     | otherwise = []
  go (u:us) = foldl glue (col u) us
  glue us u = zipWith (\ys (y:_) -> y:ys) us (col u)
  col k = map (\l -> [(/d) $ s_determinant (elemCramerPos l k ks) ms ps]) $ ls
  ls = [0..pred.length $ ms]
  ps = s_permutations ls
  d = s_determinant elemPos ms ps

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
  let b   =  [[-3], [-32], [-47], [49]]
  task a b
