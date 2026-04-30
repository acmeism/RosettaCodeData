html_table <- function(headings, nrows){
  ncols <- length(headings)
  pad_table <- function(s, char2="d"){
    pad <- paste0("<t", char2, ">", s, "</t", char2, ">", collapse="")
    paste0("<tr>", pad, "</tr>", collapse="")
  }
  theader <- pad_table(c("", headings), char2="h")
  gen_row <- function(n) c(n, sample(9999, ncols))
  tbody <- lapply(1:nrows, gen_row) |> sapply(pad_table)
  cat("<table>", theader, sep="\n")
  writeLines(tbody)
  cat("</table>\n")
}

html_table(c("X", "Y", "Z"), 3)
