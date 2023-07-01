data Circle = Circle { cx :: Double, cy :: Double, cr :: Double }

isInside :: Double -> Double -> Circle -> Bool
isInside x y c = (x - cx c) ^ 2 + (y - cy c) ^ 2 <= (cr c ^ 2)

isInsideAny :: Double -> Double -> [Circle] -> Bool
isInsideAny x y = any (isInside x y)

approximatedArea :: [Circle] -> Int -> Double
approximatedArea cs box_side = (fromIntegral count) * dx * dy
  where
    -- compute the bounding box of the circles
    x_min = minimum [cx c - cr c | c <- circles]
    x_max = maximum [cx c + cr c | c <- circles]
    y_min = minimum [cy c - cr c | c <- circles]
    y_max = maximum [cy c + cr c | c <- circles]
    dx = (x_max - x_min) / (fromIntegral box_side)
    dy = (y_max - y_min) / (fromIntegral box_side)
    count = length [0 | r <- [0 .. box_side - 1],
                        c <- [0 .. box_side - 1],
                        isInsideAny (posx c) (posy r) circles]
    posy r = y_min + (fromIntegral r) * dy
    posx c = x_min + (fromIntegral c) * dx

circles :: [Circle]
circles = [Circle ( 1.6417233788) ( 1.6121789534) 0.0848270516,
           Circle (-1.4944608174) ( 1.2077959613) 1.1039549836,
           Circle ( 0.6110294452) (-0.6907087527) 0.9089162485,
           Circle ( 0.3844862411) ( 0.2923344616) 0.2375743054,
           Circle (-0.2495892950) (-0.3832854473) 1.0845181219,
           Circle ( 1.7813504266) ( 1.6178237031) 0.8162655711,
           Circle (-0.1985249206) (-0.8343333301) 0.0538864941,
           Circle (-1.7011985145) (-0.1263820964) 0.4776976918,
           Circle (-0.4319462812) ( 1.4104420482) 0.7886291537,
           Circle ( 0.2178372997) (-0.9499557344) 0.0357871187,
           Circle (-0.6294854565) (-1.3078893852) 0.7653357688,
           Circle ( 1.7952608455) ( 0.6281269104) 0.2727652452,
           Circle ( 1.4168575317) ( 1.0683357171) 1.1016025378,
           Circle ( 1.4637371396) ( 0.9463877418) 1.1846214562,
           Circle (-0.5263668798) ( 1.7315156631) 1.4428514068,
           Circle (-1.2197352481) ( 0.9144146579) 1.0727263474,
           Circle (-0.1389358881) ( 0.1092805780) 0.7350208828,
           Circle ( 1.5293954595) ( 0.0030278255) 1.2472867347,
           Circle (-0.5258728625) ( 1.3782633069) 1.3495508831,
           Circle (-0.1403562064) ( 0.2437382535) 1.3804956588,
           Circle ( 0.8055826339) (-0.0482092025) 0.3327165165,
           Circle (-0.6311979224) ( 0.7184578971) 0.2491045282,
           Circle ( 1.4685857879) (-0.8347049536) 1.3670667538,
           Circle (-0.6855727502) ( 1.6465021616) 1.0593087096,
           Circle ( 0.0152957411) ( 0.0638919221) 0.9771215985]

main = putStrLn $ "Approximated area: " ++
                  (show $ approximatedArea circles 5000)
