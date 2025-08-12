library(stringr)

bottles <- function(){
  s <- function(n) ifelse(n==1, "", "s")
  z <- function(n) ifelse(n==0, "No more", n)
  cat(sapply(99:1, function(n) str_glue("{n} bottle{s(n)} of beer on the wall,\n",
                                        "{n} bottle{s(n)} of beer,\n",
                                        "Take one down, pass it around,\n",
                                        "{z(n-1)} bottle{s(n-1)} of beer on the wall.")), sep="\n")
}

hq9plus <- function(s){
  accumulator <- 0
  chars <- str_split_1(str_to_upper(s),"")
  for(char in chars){
    switch(char,
           "H"=cat("Hello World!","\n"),
           "Q"=cat(s, "\n"),
           "9"=bottles(),
           "+"=eval(accumulator <- accumulator+1))
  }
  cat("The value of the accumulator is", accumulator)
}

hq9plus(readline())
