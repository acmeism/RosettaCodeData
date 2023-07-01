name n = lens get set
  where get = head . dropWhile ((/= n).fst)
        set assoc (_,v) = let (prev, _:post) = break ((== n).fst) assoc
                      in prev ++ (n, v):post

fianceesOf n = guys.name n._2
fiancesOf n = girls.name n._2
