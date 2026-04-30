library(stringr)

unixdict <- read.table("unixdict.txt", col.names="words")
regexps <- c("[abc]","[def]","[ghi]","[jkl]","[mno]","[pqrs]","[tuv]","[wxyz]")
replace_regexp <- function(s,n) str_replace_all(s, regexps[n], as.character(n+1))
funs_list <- lapply(1:8, function(n) function(s) replace_regexp(s,n))
textify <- function(s) Reduce(function(x,f) f(x), funs_list, init=s)
unixdict$textified <- unixdict$words |> str_to_lower() |> textify()

valid_text <- subset(unixdict, !str_detect(words, "[^a-z]"))
num_combinations <- valid_text$textified |> unique() |> length()
is_textonym <- function(s) length(subset(valid_text, textified==s)$words)>1
num_textonyms <- Filter(is_textonym, valid_text$textified) |> unique() |> length()

find_textonyms <- function(n){
  s <- as.character(n)
  subset(unixdict, textified==s)$words
}

str_glue("There are {length(valid_text$words)} words in unixdict.txt which can be represented by the digit key mapping.",
         "They require {num_combinations} digit combinations to represent them.",
         "{num_textonyms} digit combinations represent Textonyms.", .sep="\n")

find_textonyms(2253)
