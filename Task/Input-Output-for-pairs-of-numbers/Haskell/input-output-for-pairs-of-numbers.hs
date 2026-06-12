main = do
    contents <- getContents
    let numberOfLines  =  read.head.lines$ contents
        nums  =  map (map read.words).take numberOfLines.tail.lines$ contents
        sums  =  map sum nums
    mapM_ print sums
