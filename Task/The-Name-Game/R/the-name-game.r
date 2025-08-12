library(stringr)

namegame <- function(name){
  name <- str_to_title(name)
  bfm_flags <- c("b","f","m")
  #Y is only considered a starting vowel if it is followed by a consonant
  if(str_detect(name, "^[AEIOU]|^Y[^aeiou]")) name_trunc <- str_to_lower(name)
  else name_trunc <- str_sub(name, start=2)
  switch(str_sub(name, 1, 1),
         "B"=eval(bfm_flags[1] <- ""),
         "F"=eval(bfm_flags[2] <- ""),
         "M"=eval(bfm_flags[3] <- ""))
  str_glue("{name}, {name}, bo-{bfm_flags[1]}{name_trunc}",
           "Banana-fana fo-{bfm_flags[2]}{name_trunc}",
           "Fee-fi-mo-{bfm_flags[3]}{name_trunc}",
           "{name}!", .sep="\n")
}

test_names <- c("Gary", "Earl", "Billy", "Felix", "Mary", "Yancy", "Yvonne")
sapply(test_names, namegame) |> writeLines()
