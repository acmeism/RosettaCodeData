factorials = go 1 1 where
    go n fac = f : go (n+1) (n*fac)
