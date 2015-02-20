let match2_loc s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then (false, -1) else
    let rec aux i =
      if i < 0 then (false, -1) else
        let sub = String.sub s1 i len2 in
        if (sub = s2) then (true, i) else aux (pred i)
    in
    aux (len1 - len2)
