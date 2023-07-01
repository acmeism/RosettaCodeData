local
  open Substring
in
  val trimLeft = string o dropl Char.isSpace o full
  and trimRight = string o dropr Char.isSpace o full
  and trim = string o dropl Char.isSpace o dropr Char.isSpace o full
end
