fun readLines string =
  let
    val strm = TextIO.openIn path
    fun chomp str =
      let
        val xstr = String.explode str
        val slen = List.length xstr
      in
        String.implode(List.take(xstr, (slen-1)))
      end
    fun collectLines ls s =
      case TextIO.inputLine s of
        SOME(l) => collectLines (chomp l::ls) s
        | NONE => ls
  in
    List.rev (collectLines [] strm) before TextIO.closeIn strm
  end
