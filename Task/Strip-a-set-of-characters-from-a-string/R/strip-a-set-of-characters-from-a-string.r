library(stringr)

stripchars <- function(s, chars){
  #Make sure potentially troublesome regex characters are escaped properly
  specialchars <- c("\\","^","[","]","-")
  for(char in specialchars){
    if(str_detect(chars, fixed(char))){
      chars <- str_replace_all(chars, fixed(char), str_glue("\\{char}"))
    }
  }
  regexp <- str_glue("[{chars}]")
  return(str_replace_all(s, regexp, ""))
}

stripchars("She was a soul stripper. She took my heart!", "aei")
stripchars("Bet you can't do this one! ^.*?({})[\\-|]+$", "\\^.*?({})[\\-|]+$")
