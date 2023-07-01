func1 f = f "a string"
func2 s = "func2 called with " ++ s

main = putStrLn $ func1 func2
