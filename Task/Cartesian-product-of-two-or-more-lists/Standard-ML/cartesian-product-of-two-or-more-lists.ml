fun prodList (nil,     _) = nil
  | prodList ((x::xs), ys) = map (fn y => (x,y)) ys @ prodList (xs, ys)

fun naryProdList zs = foldl (fn (xs, ys) => map op:: (prodList (xs, ys))) [[]] (rev zs)
