fun interleave x [] = [[x]]
  | interleave x (y::ys) = (x::y::ys) :: (List.map (fn a => y::a) (interleave x ys))

fun perms [] = [[]]
  | perms (x::xs) = List.concat (List.map (interleave x) (perms xs))
