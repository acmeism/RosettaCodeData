let () =
  let filenames = [
    "http://example.com/download.tar.gz";
    "CharacterModel.3DS";
    ".desktop";
    "document";
    "document.txt_backup";
    "/etc/pam.d/login"]
  in
  List.iter (fun filename ->
    Printf.printf " '%s' => '%s'\n" filename (Filename.extension filename)
  ) filenames
