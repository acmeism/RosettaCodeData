fun readLines string =
  let
    val strm = TextIO.openIn path
    (* this would remove all trailing whitespace *)
    (* fun chomp str = Substring.string (Substring.dropr Char.isSpace (Substring.full str)) *)
    (* but TextIO.inputLine guarantees that the line is newline terminated so this works equally well *)
    fun chomp str = Substring.string (Substring.trimr 1 (Substring.full str))
    fun collectLines ls s =
      case TextIO.inputLine s of
        SOME(l) => collectLines (chomp l::ls) s
        | NONE => ls
  in
    List.rev (collectLines [] strm) before TextIO.closeIn strm
  end
