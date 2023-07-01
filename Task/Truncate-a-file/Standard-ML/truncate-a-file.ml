local
  open Posix.FileSys
  val perm = S.flags [S.irusr, S.iwusr, S.irgrp, S.iwgrp, S.iroth, S.iwoth]
in
  fun truncate (path, len) =
    let
      val fd = createf (path, O_WRONLY, O.noctty, perm)
    in
      ftruncate (fd, len); Posix.IO.close fd
    end
end
