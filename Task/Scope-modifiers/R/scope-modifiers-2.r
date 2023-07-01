d <- data.frame(a=c(2,4,6), b = c(5,7,9))
attach(d)
b - a        #success
detach(d)
b - a        #produces error
