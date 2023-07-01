fun isDirEmpty(path: string) =
  let
    val dir = OS.FileSys.openDir path
    val dirEntryOpt = OS.FileSys.readDir dir
  in
    (
      OS.FileSys.closeDir(dir);
      case dirEntryOpt of
        NONE => true
      | _    => false
    )
  end;
