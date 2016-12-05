process = execState $ do
  n <- gets value
  c <- gets count
  when (n > 1) $ modify $ \env -> env { count = c + 1 }
  modify $ \env -> env { value = hailstone n }
