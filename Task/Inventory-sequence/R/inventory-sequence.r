inv_sequence <- function(lim_length=Inf, lim_value=Inf){
  counter <- iseq <- 0
  repeat{
    if(counter==0){
      if(length(iseq)==lim_length) return(iseq)
      iseq <- c(iseq, sum(iseq==0))
      if(sum(iseq==0)>=lim_value) return(iseq)
      counter <- 1
    }
    while(counter>0){
      if(length(iseq)==lim_length) return(iseq)
      next_inv <- sum(iseq==counter)
      iseq <- c(iseq, next_inv)
      if(next_inv==0){
        counter <- 0
        break
      }
      if(next_inv>=lim_value) return(iseq)
      counter <- counter+1
    }
  }
}

inv_sequence(lim_length=100)
bigseqs <- lapply(1000*(1:10), function(n) inv_sequence(lim_value=n))
lens <- sapply(bigseqs, length)
elements <- sapply(bigseqs, function(v) v[length(v)])
paste("First element >=", 1000*(1:10), "is", elements, "at index", lens) |> writeLines()

png(filename="InventorySequence-R.png", width=1920, height=1080)
plot(1:10000, inv_sequence(lim_length = 10000), type="l", xlab=NA, ylab=NA)
dev.off()
