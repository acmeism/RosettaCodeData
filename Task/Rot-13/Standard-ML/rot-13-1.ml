fun rot13char c =
  if c >= #"a" andalso c <= #"m" orelse c >= #"A" andalso c <= #"M" then
    chr (ord c + 13)
  else if c >= #"n" andalso c <= #"z" orelse c >= #"N" andalso c <= #"Z" then
    chr (ord c - 13)
  else
    c

val rot13 = String.map rot13char
