import CLPFD
import Findall

queens n qs =
    qs =:= [_ | _ <- [1..n]]
  & domain qs 1 (length qs)
  & allDifferent qs
  & allSafe qs
  & labeling [FirstFail] qs

allSafe [] = success
allSafe (q:qs) = safe q qs 1 & allSafe qs

safe :: Int -> [Int] -> Int -> Success
safe _     []  _ = success
safe q (q1:qs) p = q /=# q1+#p & q /=# q1-#p & safe q qs (p+#1)

-- oneSolution  = unpack  $ queens 8
-- allSolutions = findall $ queens 8
