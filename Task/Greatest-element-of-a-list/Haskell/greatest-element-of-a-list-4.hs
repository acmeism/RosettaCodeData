maximumBy
  :: Foldable t
  => (a -> a -> Ordering) -> t a -> a
maximumBy cmp =
  let max_ x y =
        case cmp x y of
          GT -> x
          _ -> y
  in foldr1 max_
