fun mycmp (s1, s2) =
  if size s1 <> size s2 then
    Int.compare (size s2, size s1)
  else
    String.compare (String.map Char.toLower s1, String.map Char.toLower s2)
