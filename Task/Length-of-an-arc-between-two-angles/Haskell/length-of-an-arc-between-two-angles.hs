arcLength radius angle1 angle2 = (360.0 - (abs $ angle1 - angle2)) * pi * radius / 180.0

main = putStrLn $ "arcLength 10.0 10.0 120.0 = " ++ show (arcLength 10.0 10.0 120.0)
