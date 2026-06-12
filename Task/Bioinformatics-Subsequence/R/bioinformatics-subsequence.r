bases <- c("A", "C", "T", "G")
gen_baseseq <- function(n) sample(bases, n, replace=TRUE) |> paste0(collapse="")
dna <- gen_baseseq(200)
subseq <- gen_baseseq(4)
matches <- gregexpr(subseq, dna)

cat("Random DNA sequence:\n")
for(i in 0:3) cat(substr(dna, 50*i+1, 50*(i+1)), "\n")

cat("Subsequence to find:", subseq, "\n")
if(-1 %in% matches[[1]]){
  cat("No match found.")
} else cat("Match(es) found at position(s):", matches[[1]])
