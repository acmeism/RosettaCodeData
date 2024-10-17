let match2_num s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then (false, 0) else
    let rec aux i n =
      if i < 0 then (n <> 0, n) else
        let sub = String.sub s1 i len2 in
        if (sub = s2)
        then aux (pred i) (succ n)
        else aux (pred i) (n)
    in
    aux (len1 - len2) 0
