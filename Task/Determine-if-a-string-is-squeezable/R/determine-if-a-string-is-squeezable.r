squeeze_string <- function(string, character){

    str_iterable <- strsplit(string, "")[[1]]

    message(paste0("Original String: ", "<<<", string, ">>>\n",
                   "Length: ", length(str_iterable), "\n",
                   "Character: ", character))

    detect <- rep(TRUE, length(str_iterable))


    for(i in 2:length(str_iterable)){

      if(length(str_iterable) == 0) break
      if(str_iterable[i] != character) next

      if(str_iterable[i] == str_iterable[i-1])

        detect[i] <- FALSE
    }

    squeezed_string <- paste(str_iterable[detect], collapse = "")

    message(paste0("squeezed string: ", "<<<",squeezed_string, ">>>\n",
                   "Length: ", length(str_iterable[detect])), "\n")

  }


  squeeze_string("", " ")
  squeeze_string("'If I were two-faced, would I be wearing this one?' --- Abraham Lincoln ", "-")
  squeeze_string("..1111111111111111111111111111111111111111111111111111111111111117777888", "7")
  squeeze_string("I never give 'em hell, I just tell the truth, and they think it's hell. ", ".")
  squeeze_string("                                                    --- Harry S Truman  ", " ")
  squeeze_string("                                                    --- Harry S Truman  ", "-")
  squeeze_string("                                                    --- Harry S Truman  ", "r")
  squeeze_string("  Ciao Mamma, guarda come mi diverto!!!  ", "!")
