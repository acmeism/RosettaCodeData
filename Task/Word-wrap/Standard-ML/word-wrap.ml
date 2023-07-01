fun wordWrap n s =
  let
    fun appendLine (line, text) =
      text ^ line ^ "\n"
    fun wrap (word, prev as (line, text)) =
      if size line + 1 + size word > n
      then (word, appendLine prev)
      else (line ^ " " ^ word, text)
  in
    case String.tokens Char.isSpace s of
      [] => ""
    | (w :: ws) => appendLine (foldl wrap (w, "") ws)
  end

val () = (print o wordWrap 72 o TextIO.inputAll) TextIO.stdIn
