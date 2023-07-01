t1 = Record "jsmith" "x" 1001 1000 "/home/jsmith" "/bin/bash"
            (Gecos "Joe Smith" "Room 1007" "(234)555-8917" "(234)555-0077" "jsmith@rosettacode.org")

t2 = Record "jdoe" "x" 1002 1000 "/home/jdoe" "/bin/bash"
            (Gecos "Jane Doe" "Room 1004" "(234)555-8914" "(234)555-0044" "jdoe@rosettacode.org")

t3 = Record "xyz" "x" 1003 1000 "/home/xyz" "/bin/bash"
            (Gecos "X Yz" "Room 1003" "(234)555-8913" "(234)555-0033" "xyz@rosettacode.org")

main = do
    let path = "test.txt"
    forM [t1,t2,t3] (addRecord path)
    lastLine <- fmap (last . lines) (readFile path)
    putStrLn lastLine
