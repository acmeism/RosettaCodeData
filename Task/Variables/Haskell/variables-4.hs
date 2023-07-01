funkshun m = case foo m of
    [a, b]           -> a - b
    a : b : c : rest -> a + b - c + sum rest
    a                -> sum a
