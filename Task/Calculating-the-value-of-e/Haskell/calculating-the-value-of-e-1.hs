------ APPROXIMATION OF E OBTAINED AFTER N ITERATIONS ----

eApprox :: Int -> Double
eApprox n = sum . map (1 /) $ scanl (*) 1 [1..n]

--------------------------- TEST -------------------------
main :: IO ()
main = print $ eApprox 20
