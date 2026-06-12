library(stringr)

abc_correlation <- function(){
  s <- readline(prompt="Please input a word. ")
  str_count(s, "a")==str_count(s, "b") & str_count(s, "b")==str_count(s, "c")
}
