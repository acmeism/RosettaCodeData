#Retrieving
url_day <- function(n) sprintf("http://tclers.tk/conferences/tcl/%s.tcl", Sys.Date()-n)
retrieve <- function(n) readLines(con=url(url_day(n)))
#Adding an extra day to deal with time zone issue
logs <- lapply(-1:9, retrieve)
names(logs) <- sapply(-1:9, url_day)
if("<Title>URL Not Found</Title>" %in% logs[[1]]) logs[[1]] <- NULL

#Searching
results <- lapply(seq_along(logs), function(n) grep(s, logs[[n]], fixed=TRUE, value=TRUE))
names(results) <- names(logs)

for(i in seq_along(results)){
  if(length(results[[i]])==0){
    results[[i]] <- "No results found"
  }
}

print(results, quote=FALSE)
