main = mapM_ (\f -> putStr(f ++ "\t") >> print (f `isExt` extensions)) files
  where
    files = [ "MyData.a##"
            , "MyData.tar.Gz"
            , "MyData.gzip"
            , "MyData.7z.backup"
            , "MyData..."
            , "MyData"
            , "MyData_v1.0.tar.bz2"
            , "MyData_v1.0.bz2" ]
    extensions = ["zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2"]
