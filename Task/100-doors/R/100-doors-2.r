x <- rep(1, 100)
for (i in 1:100-1) {
    x <- xor(x, rep(c(rep(0,i),1), length.out=100))
}
which(!x)
