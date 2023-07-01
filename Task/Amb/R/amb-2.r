sentence1 <- c("that", "thing", "grows", "slowly")
sentence2 <- c("rosetta", "code", "is", "cool")
sentence  <- list(sentence1, sentence2)
sapply(sentence, checkSentence)
[1]  TRUE FALSE

set1 <- c("the", "that", "a")
set2 <- c("frog", "elephant", "thing")
set3 <- c("walked", "treaded", "grows")
set4 <- c("slowly", "quickly")
sets <- list(set1, set2, set3, set4)
amb(sets)
$`26`
[1] "that"   "thing"  "grows"  "slowly"
