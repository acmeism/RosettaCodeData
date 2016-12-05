foldlZipWith::(a -> b -> c) -> (d -> c -> d) -> d -> [a] -> [b]  -> d
foldlZipWith _ _ u [] _          = u
foldlZipWith _ _ u _ []          = u
foldlZipWith f g u (x:xs) (y:ys) = foldlZipWith f g (g u (f x y)) xs ys

foldl1ZipWith::(a -> b -> c) -> (c -> c -> c) -> [a] -> [b] -> c
foldl1ZipWith _ _ [] _          = error "First list is empty"
foldl1ZipWith _ _ _ []          = error "Second list is empty"
foldl1ZipWith f g (x:xs) (y:ys) = foldlZipWith f g (f x y) xs ys

multAdd::(a -> b -> c) -> (c -> c -> c) -> [[a]] -> [[b]] -> [[c]]
multAdd f g xs ys = map (\us -> foldl1ZipWith (\u vs -> map (f u) vs) (zipWith g) us ys) xs

mult:: Num a => [[a]] -> [[a]] -> [[a]]
mult xs ys = multAdd (*) (+) xs ys

test a b = do
  let c = mult a b
  putStrLn "a ="
  mapM_ print a
  putStrLn "b ="
  mapM_ print b
  putStrLn "c = a * b = mult a b ="
  mapM_ print c

main = test [[1, 2],[3, 4]] [[-3, -8, 3],[-2,  1, 4]]
