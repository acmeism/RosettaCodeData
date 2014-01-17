median xs | null xs  = Nothing
          | odd  len = Just $ xs !! mid
          | even len = Just $ meanMedian
                where  len = length xs
                       mid = len `div` 2
                       meanMedian = (xs !! mid + xs !! (mid+1)) / 2
median :: Fractional a => [a] -> Maybe a
