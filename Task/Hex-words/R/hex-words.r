library(stringr)

unixdict <- read.table("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt", col.names="words")
hexwords <- subset(unixdict, str_detect(words,"^[a-f]{4,}$"))
hexwords$decimal <- strtoi(hexwords$words, 16L)

#Method 1 for calculating digital root: casting to a string (slower, but accurate)
dig_root <- function(n){
  while(n>9){
    vec_str <- str_split_1(as.character(n),"")
    dig_sum <- sum(as.numeric(vec_str))
    n <- dig_sum
  }
  return(n)
}

#Method 2: using modulus operators recursively (can be inaccurate for very large n)
dig_root <- function(n) ifelse(n>9, dig_root(n%%10+dig_root(n%/%10)), n)

#Method 3: using a mathematical formula (probably the fastest way)
dig_root <- function(n) ifelse(n==0, 0, 1+(n-1)%%9)

hexwords$root <- sapply(hexwords$decimal, dig_root)

hexwords <- sort_by(hexwords, ~root)
rownames(hexwords) <- NULL
print(hexwords)

#The second part is impossible to do with a single regex AFAIK, so check strings by counting instances of each letter
chars <- letters[1:6]
counts_logical <- function(s){
  counts <- sapply(chars, function(char) str_count(s, char))
  sum(counts>0)
}

hexwords$has4distinct <- sapply(hexwords$words, counts_logical)>3

hexwords_distinct <- subset(hexwords, has4distinct)
hexwords_distinct <- sort_by(hexwords_distinct, ~rev(decimal))
rownames(hexwords_distinct) <- NULL
print(hexwords_distinct[,1:3])
