t :: Template Int
t = List [ List [Val 1, Val 2]
         , List [Val 3, Val 4, Val 10]
         , Val 5]

payloads :: [(Int, String)]
payloads = [(i, "payload#"++show i) | i <- [0..6]]
