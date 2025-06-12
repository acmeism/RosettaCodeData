library(stringi)

unixdict <- read.table("unixdict.txt", col.names="forwards")
unixdict$backwards <- stri_reverse(unixdict$forwards)

#Remove all actual palindromes, as we do not want those
unixdict <- subset(unixdict, forwards!=backwards)

for(i in seq_along(unixdict$forwards)){
  unixdict$issemordnilap[i] <- with(unixdict, forwards[i] %in% backwards)
}

semordnilaps <- subset(unixdict, (issemordnilap==TRUE)&(forwards>backwards), select=-issemordnilap)
length(semordnilaps$forwards)

random <- sample(seq_along(semordnilaps$forwards), 5, replace=FALSE)
print(semordnilaps[random,], row.names=FALSE)
