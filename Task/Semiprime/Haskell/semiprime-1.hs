isSemiprime :: Int -> Bool
isSemiprime n = (length factors) == 2 && (product factors) == n ||
                (length factors) == 1 && (head factors) ^ 2 == n
                    where factors = primeFactors n
