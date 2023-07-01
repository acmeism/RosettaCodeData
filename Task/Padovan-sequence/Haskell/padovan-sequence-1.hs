-- list of Padovan numbers using recurrence
pRec = map (\(a,_,_) -> a) $ iterate (\(a,b,c) -> (b,c,a+b)) (1,1,1)

-- list of Padovan numbers using self-referential lazy lists
pSelfRef = 1 : 1 : 1 : zipWith (+) pSelfRef (tail pSelfRef)

-- list of Padovan numbers generated from floor function
pFloor = map f [0..]
    where f n = floor $ p**fromInteger (pred n) / s + 0.5
          p   = 1.324717957244746025960908854
          s   = 1.0453567932525329623

-- list of L-system strings
lSystem = iterate f "A"
    where f []      = []
          f ('A':s) = 'B':f s
          f ('B':s) = 'C':f s
          f ('C':s) = 'A':'B':f s

-- check if first N elements match
checkN n as bs = take n as == take n bs

main = do
    putStr "P_0 .. P_19: "
    putStrLn $ unwords $ map show $ take 20 pRec

    putStr "The floor- and recurrence-based functions "
    putStr $ if checkN 64 pRec pFloor then "match" else "do not match"
    putStr " from P_0 to P_63.\n"

    putStr "The self-referential- and recurrence-based functions "
    putStr $ if checkN 64 pRec pSelfRef then "match" else "do not match"
    putStr " from P_0 to P_63.\n\n"

    putStr "The first 10 L-system strings are:\n"
    putStrLn $ unwords $ take 10 lSystem

    putStr "\nThe floor- and L-system-based functions "
    putStr $ if checkN 32 pFloor (map length lSystem)
             then "match" else "do not match"
    putStr " from P_0 to P_31.\n"
