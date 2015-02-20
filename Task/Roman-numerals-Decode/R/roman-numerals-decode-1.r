romanToArabic <- function(roman) {
  romanLookup <- c(I=1L, V=5L, X=10L, L=50L, C=100L, D=500L, M=1000L)
  rSplit <- strsplit(toupper(roman), character(0)) # Split input vector into characters
  toArabic <- function(item) {
    digits <- romanLookup[item]
    if (length(digits) > 1L) {
      smaller <- (digits[-length(digits)] < digits[-1L])
      digits[smaller] <- - digits[smaller]
    }
    sum(digits)
  }
  vapply(rSplit, toArabic, integer(1))
}
