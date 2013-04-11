import Data.List

breakIncl p =  uncurry ((. take 1). (++)). break p

taskLLB k = map (breakIncl (==k)). breakIncl (k`elem`)
