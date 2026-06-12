unixdict <- readLines(con=url("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"))

regexp <- "(^([aeiou][^aieou]){5,}[aieou]?$)|(^([^aeiou][aieou]){5,}[^aieou]?$)"

alternators <- subset(unixdict, grepl(regexp, unixdict))

print(matrix(c(alternators, rep("",3)), nrow=14, ncol=5), quote=FALSE)
