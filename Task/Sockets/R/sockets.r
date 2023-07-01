s <- make.socket(port = 256)
write.socket(s, "hello socket world")
close.socket(s)
