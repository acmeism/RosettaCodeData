x <- 5
y <- x
pryr::address(x)
pryr::address(y)

y <- y + 1

pryr::address(x)
pryr::address(y)
