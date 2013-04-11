let match3 s1 s2 =
  let len1 = String.length s1
  and len2 = String.length s2 in
  if len1 < len2 then false else
    let sub = String.sub s1 (len1 - len2) len2 in
    (sub = s2)
