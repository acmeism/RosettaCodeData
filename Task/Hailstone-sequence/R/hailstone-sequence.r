### PART 1:
makeHailstone <- function(n){
  hseq <- n
  while (hseq[length(hseq)] > 1){
    current.value <- hseq[length(hseq)]
    if (current.value %% 2 == 0){
      next.value <- current.value / 2
    } else {
      next.value <- (3 * current.value) + 1
    }
    hseq <- append(hseq, next.value)
  }
  return(list(hseq=hseq, seq.length=length(hseq)))
}

### PART 2:
twenty.seven <- makeHailstone(27)
twenty.seven$hseq
twenty.seven$seq.length

### PART 3:
max.length <- 0;  lower.bound <- 1;  upper.bound <- 100000

for (index in lower.bound:upper.bound){
  current.hseq <- makeHailstone(index)
  if (current.hseq$seq.length > max.length){
    max.length <- current.hseq$seq.length
    max.index  <- index
  }
}

cat("Between ", lower.bound, " and ", upper.bound, ", the input of ",
    max.index, " gives the longest hailstone sequence, which has length ",
    max.length, ". \n", sep="")
