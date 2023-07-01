test = mapM_ display dates
  where
    display d = putStr (show d ++ " -> ") >> print (fromYMD d)
    dates = [(2012,2,28)
            ,(2012,2,29)
            ,(2012,3,1)
            ,(2012,3,14)
            ,(2012,3,15)
            ,(2010,9,2)
            ,(2010,12,31)
            ,(2011,1,1)]
