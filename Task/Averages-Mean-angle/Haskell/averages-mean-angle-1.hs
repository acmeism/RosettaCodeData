import Data.Complex (cis, phase)

meanAngle
  :: RealFloat c
  => [c] -> c
meanAngle = (/ pi) . (* 180) . phase . sum . map (cis . (/ 180) . (* pi))

main :: IO ()
main =
  mapM_
    (\angles ->
        putStrLn $
        "The mean angle of " ++
        show angles ++ " is: " ++ show (meanAngle angles) ++ " degrees")
    [[350, 10], [90, 180, 270, 360], [10, 20, 30]]
