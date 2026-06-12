schwartzian <- function(v, f) sort_by(data.frame("words"=v, "keys"=f(v)), ~keys)$words

schwartzian(c("Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"), nchar)
