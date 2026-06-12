get_file_ext <- function(s){
  ext <- regmatches(s, regexec("\\.[A-Za-z0-9]+$", s))
  ifelse(length(ext[[1]])==0, "", ext[[1]])
}

test_paths <- c("http://example.com/download.tar.gz",
                "CharacterModel.3DS",
                ".desktop",
                "document",
                "document.txt_backup",
                "/etc/pam.d/login")

sapply(test_paths, get_file_ext)
