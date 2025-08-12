soloway <- function(){
  vals <- numeric(0)
  repeat{
    entry <- readline(prompt="Enter integer rainfall value (99999 to quit): ")
    if(is.na(as.numeric(entry))){
      cat("Input must be numeric, please re-enter", "\n")
      entry <- NULL
    }
    entry <- as.numeric(entry)
    if(length(entry)>0){
      if(entry%%1!=0){
        cat("Input must be an integer, please re-enter", "\n")
        entry <- NULL
      }
    }
    vals <- c(vals, entry)
    if(99999 %in% vals) break
    cat("Average rainfall:", mean(vals))
  }
}

soloway()
