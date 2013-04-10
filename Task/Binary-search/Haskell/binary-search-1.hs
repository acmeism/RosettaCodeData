binarySearch :: Integral a => (a -> Ordering) -> (a, a) -> Maybe a
binarySearch p (low,high)
  | high < low = Nothing
  | otherwise =
      let mid = (low + high) `div` 2 in
      case p mid of
        LT -> binarySearch p (low, mid-1)
        GT -> binarySearch p (mid+1, high)
        EQ -> Just mid
