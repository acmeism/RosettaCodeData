max.subseq <- function(x) {
  cumulative <- cumsum(x)
  min.cumulative.so.far <- Reduce(min, cumulative, accumulate=TRUE)
  end <- which.max(cumulative-min.cumulative.so.far)
  begin <- which.min(c(0, cumulative[1:end]))
  if (end >= begin) x[begin:end] else x[c()]
}
