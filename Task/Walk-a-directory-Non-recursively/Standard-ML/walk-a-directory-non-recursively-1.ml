fun dirEntries path =
  let
    fun loop strm =
      case OS.FileSys.readDir strm of
        SOME name => name :: loop strm
      | NONE => []
    val strm = OS.FileSys.openDir path
  in
    loop strm before OS.FileSys.closeDir strm
  end
