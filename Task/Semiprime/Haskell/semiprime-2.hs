isSemiprime :: Int -> Bool
isSemiprime n = case (primeFactors n) of
                   [f1, f2] -> f1 * f2 == n
                   otherwise -> False
