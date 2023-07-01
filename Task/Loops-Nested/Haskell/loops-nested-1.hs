import Data.List
breakIncl :: (a -> Bool) -> [a] -> [a]
breakIncl p =  uncurry ((. take 1). (++)). break p

taskLLB k = map (breakIncl (==k)). breakIncl (k `elem`)
