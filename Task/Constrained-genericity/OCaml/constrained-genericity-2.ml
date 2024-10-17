module MakeFoodBox(A : Eatable) = struct
  type elt = A.t
  type t = F of elt list
  let make_box_from_list xs = F xs
end
