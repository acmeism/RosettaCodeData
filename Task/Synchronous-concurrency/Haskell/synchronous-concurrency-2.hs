reader putLine putEOF takeCount =
    do ls <- fmap lines (readFile "input.txt")
       mapM putLine ls
       putEOF
       n <- takeCount
       print n
