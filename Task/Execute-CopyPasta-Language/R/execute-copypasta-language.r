copypasta <- function(filepath) {
  text <- readLines(filepath)
  clipboard <- character(0)
  for (i in seq_along(text)) {
    currentline <- text[i]
    if (currentline == "Pasta!") {
      writeLines(clipboard)
      break
    }
    nextline <- text[i+1]
    con <- ifelse(
      nextline == "TheF*ckingCode",
      filepath,
      nextline
    )
    copytext <- switch(
      currentline,
      "Copy" = nextline,
      "CopyFile" = readLines(con),
      "Duplicate" = rep(clipboard, times = as.numeric(nextline)),
    )
    clipboard <- c(clipboard, copytext)
  }
  if (.Platform$OS.type == "windows") writeClipboard(clipboard)
}

copypasta(readline())
