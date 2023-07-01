collapse_string <- function(string){

    str_iterable <- strsplit(string, "")[[1]]

    message(paste0("Original String: ", "<<<", string, ">>>\n",
                   "Length: ", length(str_iterable)))

    detect <- rep(TRUE, length(str_iterable))


    for(i in 2:length(str_iterable)){

      if(length(str_iterable)==0) break

      if(str_iterable[i] == str_iterable[i-1])

        detect[i] <- FALSE
    }

    collapsed_string <- paste(str_iterable[detect],collapse = "")

    message(paste0("Collapsed string: ", "<<<",collapsed_string, ">>>\n",
                   "Length: ", length(str_iterable[detect])), "\n")

}

test_strings <- c(
  "",
  "'If I were two-faced, would I be wearing this one?' --- Abraham Lincoln ",
  "..1111111111111111111111111111111111111111111111111111111111111117777888",
  "I never give 'em hell, I just tell the truth, and they think it's hell. ",
  "                                                    --- Harry S Truman  ",
  "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
  "headmistressship",
  "aardvark",
  "Ciao Mamma, guarda come mi diverto!!"
)

for(test in test_strings){
  collapse_string(test)
}
