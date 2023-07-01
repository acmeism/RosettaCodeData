main = runProgram $
  do
    start <- label
    lift $ putStrLn "Enter your name, please"
    name <- lift $ getLine
    if name == ""
      then do lift $ putStrLn "Name can't be empty!"
              goto start
      else lift $ putStrLn ("Hello, " ++ name)
