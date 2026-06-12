fun multiperms [] _ = [[]]
  | multiperms _ 0 = [[]]
  | multiperms xs n =
  let
    val rest = multiperms xs (n-1)
  in
    List.concat (List.map (fn a => (List.map (fn b => a::b) rest)) xs)
  end
