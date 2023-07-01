main = do
  let xs = [-2, -1, 0, 1, 2, 6.2831853,
            16, 57.2957795, 359, 399, 6399, 1000000]

  -- using `to` and `angle` with type application
  putStrLn "converting to radians"
  print $ to @Rad . angle @Rad <$> xs
  print $ to @Rad . angle @Deg <$> xs
  print $ to @Rad . angle @Grad <$> xs
  print $ to @Rad . angle @Mil <$> xs
  print $ to @Rad . angle @Slope <$> xs

  -- using `from` with type application
  putStrLn "\nconverting to degrees"
  print $ from @Rad @Deg . angle <$> xs
  print $ from @Deg @Deg . angle <$> xs
  print $ from @Grad @Deg . angle <$> xs
  print $ from @Mil @Deg . angle <$> xs
  print $ from @Slope @Deg . angle <$> xs

  -- using normalization for each unit
  putStrLn "\nconverting to grads"
  print $ to @Grad . normalize . Rad <$> xs
  print $ to @Grad . normalize . Deg <$> xs
  print $ to @Grad . normalize . Grad <$> xs
  print $ to @Grad . normalize . Mil <$> xs
  print $ to @Grad . normalize . Slope <$> xs

  -- using implicit type annotation
  putStrLn "\nconverting to mils"
  print $ (from :: Rad -> Mil) . angle <$> xs
  print $ (from :: Deg -> Mil) . angle <$> xs
  print $ (from :: Grad -> Mil) . angle <$> xs
  print $ (from :: Mil -> Mil) . angle <$> xs
  print $ (from :: Slope -> Mil) . angle <$> xs
