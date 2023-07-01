fun stripchars (string, chars) = let
  fun aux c =
    if String.isSubstring (str c) chars then
      ""
    else
      str c
in
  String.translate aux string
end
