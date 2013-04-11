approx f xs ws = sum [w * f x | (x,w) <- zip xs ws]

integrateOpen :: Fractional a => a -> [a] -> (a -> a) -> a -> a -> Int -> a
integrateOpen v vs f a b n = approx f xs ws * h / v where
  m = fromIntegral (length vs) * n
  h = (b-a) / fromIntegral m
  ws = concat $ replicate n vs
  c = a + h/2
  xs = [c + h * fromIntegral i | i <- [0..m-1]]

integrateClosed :: Fractional a => a -> [a] -> (a -> a) -> a -> a -> Int -> a
integrateClosed v vs f a b n = approx f xs ws * h / v where
  m = fromIntegral (length vs - 1) * n
  h = (b-a) / fromIntegral m
  ws = overlap n vs
  xs = [a + h * fromIntegral i | i <- [0..m]]

overlap :: Num a => Int -> [a] -> [a]
overlap n []  = []
overlap n (x:xs) = x : inter n xs where
  inter 1 ys     = ys
  inter n []     = x : inter (n-1) xs
  inter n [y]    = (x+y) : inter (n-1) xs
  inter n (y:ys) = y : inter n ys

intLeftRect  = integrateClosed  1 [1,0]
intMidRect   = integrateOpen    1 [1]
intRightRect = integrateClosed  1 [0,1]
intTrapezium = integrateClosed  2 [1,1]
intSimpson   = integrateClosed  3 [1,4,1]

uncurry4 f ~(a, b, c, d) = f a b c d

main = do
    let m1 = "rectangular left:    "
    let m2 = "rectangular middle:  "
    let m3 = "rectangular right:   "
    let m4 = "trapezium:           "
    let m5 = "simpson:             "

    let arg1 = ((\x -> x ^ 3), 0, 1, 100)
    putStrLn $ m1 ++ (show $ uncurry4 intLeftRect arg1)
    putStrLn $ m2 ++ (show $ uncurry4 intMidRect arg1)
    putStrLn $ m3 ++ (show $ uncurry4 intRightRect arg1)
    putStrLn $ m4 ++ (show $ uncurry4 intTrapezium arg1)
    putStrLn $ m5 ++ (show $ uncurry4 intSimpson arg1)
    putStrLn ""

    let arg2 = ((\x -> 1 / x), 1, 100, 1000)
    putStrLn $ m1 ++ (show $ uncurry4 intLeftRect arg2)
    putStrLn $ m2 ++ (show $ uncurry4 intMidRect arg2)
    putStrLn $ m3 ++ (show $ uncurry4 intRightRect arg2)
    putStrLn $ m4 ++ (show $ uncurry4 intTrapezium arg2)
    putStrLn $ m5 ++ (show $ uncurry4 intSimpson arg2)
    putStrLn ""

    let arg3 = ((\x -> x), 0, 5000, 5000000)
    putStrLn $ m1 ++ (show $ uncurry4 intLeftRect arg3)
    putStrLn $ m2 ++ (show $ uncurry4 intMidRect arg3)
    putStrLn $ m3 ++ (show $ uncurry4 intRightRect arg3)
    putStrLn $ m4 ++ (show $ uncurry4 intTrapezium arg3)
    putStrLn $ m5 ++ (show $ uncurry4 intSimpson arg3)
    putStrLn ""

    let arg4 = ((\x -> x), 0, 6000, 6000000)
    putStrLn $ m1 ++ (show $ uncurry4 intLeftRect arg4)
    putStrLn $ m2 ++ (show $ uncurry4 intMidRect arg4)
    putStrLn $ m3 ++ (show $ uncurry4 intRightRect arg4)
    putStrLn $ m4 ++ (show $ uncurry4 intTrapezium arg4)
    putStrLn $ m5 ++ (show $ uncurry4 intSimpson arg4)
