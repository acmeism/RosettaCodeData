main = do
  let result = map (fixedPoint process) environments
  mapM_ (prettyPrint value) result
  putStrLn (replicate 36 '-')
  putStrLn "Counts: "
  prettyPrint (count . last) result
