let mycmp s1 s2 =
  if String.length s1 <> String.length s2 then
    compare (String.length s2) (String.length s1)
  else
    String.compare (String.lowercase s1) (String.lowercase s2)
