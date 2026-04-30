test_files <- c("MyData.a##",
                "MyData.tar.Gz",
                "MyData.gzip",
                "MyData.7z.backup",
                "MyData...",
                "MyData",
                "MyData_v1.0.tar.bz2",
                "MyData_v1.0.bz2")

extensions <- c("zip", "rar", "7z", "gz", "archive", "a##", "tar.bz2")

has_ext <- function(file, exts){
  file_lower <- tolower(file)
  for(ext in exts){
    if(endsWith(file_lower, paste0(".", ext))) return(TRUE)
  }
  return(FALSE)
}

sapply(test_files, function(file) has_ext(file, extensions))
