File <- "~/test.csv"
Opened <- readLines(con = File)
Size <- length(Opened)

HTML <- "~/test.html"

Table <- list()

for(i in 1:Size)
{
  #i=1
  Split <- unlist(strsplit(Opened[i],split = ","))
  Table[i] <- paste0("<td>",Split,"</td>",collapse = "")
  Table[i] <- paste0("<tr>",Table[i],"</tr>")
}

Table[1] <- paste0("<table>",Table[1])
Table[length(Table)] <- paste0(Table[length(Table)],"</table>")

writeLines(as.character(Table), HTML)
