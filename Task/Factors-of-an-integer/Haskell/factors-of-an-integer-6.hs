import Data.List
tuple_to_list xs = fst xs ++ snd xs
factors_co n = sort (tuple_to_list (unzip
        [ (i, (div n i)) | i <- [1..floor (sqrt (fromIntegral n))-1]
                         , mod n i == 0]) ++
        [  i             | i <- [floor (sqrt (fromIntegral n))]
                         , mod n i == 0])
