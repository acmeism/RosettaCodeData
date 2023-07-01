fun forward_difference xs = ListPair.map op- (tl xs, xs)

fun nth_forward_difference n xs =
  if n = 0 then
    xs
  else
    nth_forward_difference (n-1) (forward_difference xs)
