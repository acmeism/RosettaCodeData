val mtime = OS.FileSys.modTime filename; (* returns a Time.time data structure *)

(* unfortunately it seems like you have to set modification & access times together *)
OS.FileSys.setTime (filename, NONE); (* sets modification & access time to now *)
(* equivalent to: *)
OS.FileSys.setTime (filename, SOME (Time.now ()))
