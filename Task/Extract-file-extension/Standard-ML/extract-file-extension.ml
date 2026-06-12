fun fileExt path : string =
  getOpt (Option.composePartial (Option.filter (CharVector.all Char.isAlphaNum), OS.Path.ext) path, "")

val tests = [
  "http://example.com/download.tar.gz",
  "CharacterModel.3DS",
  ".desktop",
  "document",
  "document.txt_backup",
  "/etc/pam.d/login"
]

val () = app (fn s => print (s ^ " -> \"" ^ fileExt s ^ "\"\n")) tests
