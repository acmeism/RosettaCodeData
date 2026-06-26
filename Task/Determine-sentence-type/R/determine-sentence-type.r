library(stringr)

check_end <- function(s) {
  switch(str_extract(s, "\\S(?=\\s*$)"), "?" = "Q", "!" = "E", "." = "S", "N")
}

sentence_types <- function(s) {
  types <- str_split_1(s, boundary("sentence")) |> sapply(check_end)
  str_glue("{types} | {names(types)}")
}

sentence_types("hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it")
