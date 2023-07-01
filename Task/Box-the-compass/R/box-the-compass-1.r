# Build a table of directions
pts <- data.frame(
  des = c("N", "NxE", "NNE", "NExN", "NE", "NExE", "ENE", "ExN",
          "E", "ExS", "ESE", "SExE", "SE", "SExS", "SSE", "SxE",
          "S", "SxW", "SSW", "SWxS", "SW", "SWxW", "WSW", "WxS",
          "W", "WxN", "WNW", "NWxW", "NW", "NWxN", "NNW", "NxW",
          "N")
)
pts$deg <- seq(0, 360, 360/32)

heading <- Vectorize(function(deg) {
  res <- pts
  # Calculate the absolute difference between each
  # point on the table and the function input
  res$diff <- abs(res$deg - deg)

  # Sort the table by abs difference, return the first
  res <- res[order(res$diff), ]
  res[1,]$des[1]
})
