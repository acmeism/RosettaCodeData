diff_bearing <- function(b1, b2){
  r <- (b2-b1)%%360
  ifelse(r>180, r-360, r)
}

test_bearings <- list(c(20, 45), c(-45, 45), c(-85, 90),
                      c(-95, 90), c(-45, 125), c(-45, 145),
                      c(29.4803, -88.6381), c(-78.3251, -159.036))

test_bigbearings <- list(c(-70099.74233810938, 29840.67437876723),
                         c(-165313.6666297357, 33693.9894517456),
                         c(1174.8380510598456, -154146.66490124757),
                         c(60175.77306795546, 42213.07192354373))

db_unary <- function(v) do.call(diff_bearing, as.list(v))
sapply(test_bearings, db_unary)
sapply(test_bigbearings, db_unary)
