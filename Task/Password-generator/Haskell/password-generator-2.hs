import Options

data Opts = Opts { optLength :: Int
                 , optCount :: Int
                 , optReadable :: Bool }

instance Options Opts where
    defineOptions = Opts <$>
      simpleOption "length" 8 "password length" <*>
      simpleOption "count" 1 "number of passwords to be generated" <*>
      simpleOption "readable" False "Whether to use only readable characters"

main = runCommand $ \opts args -> do
  let n = optCount opts
      l = optLength opts
      s = if (optReadable opts)
          then zipWith (\\) charSets visualySimilar
          else charSets
  res <- replicateM n (password s (max 4 l))
  mapM_ putStrLn res
  where
    charSets = [ ['a'..'z']
               , ['A'..'Z']
               , ['0'..'9']
               , "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~" ]

    visualySimilar = ["l","IOSZ","012","!|.,"]
