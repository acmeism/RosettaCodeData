digits base = map (`mod` base) . takeWhile (> 0) . iterate (`div` base)
