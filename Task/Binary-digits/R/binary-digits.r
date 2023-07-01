dec2bin <- function(num) {
  ifelse(num == 0,
         0,
         sub("^0+","",paste(rev(as.integer(intToBits(num))), collapse = ""))
  )
}

for (anumber in c(0, 5, 50, 9000)) {
         cat(dec2bin(anumber),"\n")
}
