regexp_once <- function(s) paste0("^[^",s,"]*",s,"[^",s,"]*$")
appears_once <- function(s, char) grepl(regexp_once(char), s)

list_uniques <- function(v){
  vec_chars <- strsplit(v, "") |> unlist() |> unique()
  uniques <- character(0)
  for(char in vec_chars){
    bools <- sapply(v, function(s) appears_once(s, char))
    if(all(bools)) uniques <- c(uniques, char)
  }
  uniques |> sort() |> cat()
}

list_uniques(c("1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"))
