chr <- function(n) {
  rawToChar(as.raw(n))
}

idx <- 32
while (idx < 128) {
  for (i in 0:5) {
	num <- idx + i
	if (num<100) cat(" ")
        cat(num,": ")
	if (num == 32) { cat("Spc "); next }
        if (num == 127) { cat("Del "); next } 	
	cat(chr(num),"  ")
  }
  idx <- idx + 6
  cat("\n")
}
