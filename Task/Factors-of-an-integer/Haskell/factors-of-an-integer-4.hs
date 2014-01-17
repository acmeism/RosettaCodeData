import Data.List
tuple_to_list lt = (fst lt) ++ (snd lt)
factors_co n = sort (tuple_to_list(unzip
        [ (j, (div n j)) | j <-
                [i | i <-
                        [1..truncate (sqrt (fromIntegral n))]
                        , (mod n i) == 0]] ))
