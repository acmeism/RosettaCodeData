get_file_ext <- function(s) {
  ext <- regmatches(s, regexec("\\.[A-Za-z0-9]+$", s))
  ifelse(sapply(ext, length) == 0, "None", ext) |> unlist()
}

test_paths <- c(
  "http://example.com/download.tar.gz",
  "CharacterModel.3DS",
  ".desktop",
  "document",
  "document.txt_backup",
  "/etc/pam.d/login"
)

paste(test_paths, "->", get_file_ext(test_paths)) |> writeLines()
