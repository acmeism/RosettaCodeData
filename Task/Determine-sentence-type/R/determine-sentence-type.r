library(stringr)

sentence_types <- function(s){
  sentences <- str_split_1(s, boundary("sentence"))
  check_end <- function(s){
    switch(str_extract(s, "\\S(?=\\s*$)"), `?`="Q", `!`="E", `.`="S", "N")
  }
  types <- sapply(sentences, check_end)
  for(i in seq_along(types)){
    writeLines(str_glue("{types[i]} | {names(types)[i]}"))
  }
}

sentence_types("hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it")
