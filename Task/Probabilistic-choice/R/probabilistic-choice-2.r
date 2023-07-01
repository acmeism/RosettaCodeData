library(ggplot2)
qplot(factor(names(prob), levels = names(prob)), hebrew, geom = "histogram")
