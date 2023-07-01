RMS <- function(x, na.rm = F) sqrt(mean(x^2, na.rm = na.rm))

RMS(1:10)
# [1] 6.204837

RMS(c(NA, 1:10))
# [1] NA

RMS(c(NA, 1:10), na.rm = T)
# [1] 6.204837
