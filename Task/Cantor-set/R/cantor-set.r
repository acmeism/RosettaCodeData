cantorSet <- function() {
  depth <- 6L
  cs <- vector('list', depth)
  cs[[1L]] <- c(0, 1)
  for(k in seq_len(depth)) {
    cs[[k + 1L]] <- unlist(sapply(seq_len(length(cs[[k]]) / 2L), function(j) {
      p <- cs[[k]][2L] / 3
      h <- 2L * (j - 1L)
      c(
        cs[[k]][h + 1L] + c(0, p),
        cs[[k]][h + 2L] - c(p, 0)
      )
    }, simplify = FALSE))
  }
  cs
}

cantorSetGraph <- function() {
  cs <- cantorSet()

  u <- unlist(cs)

  df <- data.frame(
    x_start = u[seq_along(u) %% 2L == 1L],
    x_end   = u[seq_along(u) %% 2L == 0L],
    depth   = unlist(lapply(cs, function(e) {
      l <- length(e)
      n <- 0
      while(l > 1) {
        n <- n + 1L
        l <- l / 2
      }
      rep(n, length(e) / 2)
    }))
  )

  require(ggplot2)
  g <- ggplot(df, aes_string(x = 'x_start', y = 'depth')) +
    geom_segment(aes_string(xend = 'x_end', yend = 'depth', size = 3)) +
    scale_y_continuous(trans = "reverse") +
    theme(
      axis.title = element_blank(),
      axis.line = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      legend.position = 'none',
      aspect.ratio = 1/5
    )

    list(graph = g, data = df, set = cs)
}
