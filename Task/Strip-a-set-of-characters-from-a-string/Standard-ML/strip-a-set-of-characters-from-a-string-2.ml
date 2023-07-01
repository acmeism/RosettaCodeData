fun stripchars (string, chars) =
  String.concat (String.tokens (fn c => String.isSubstring (str c) chars) string)
