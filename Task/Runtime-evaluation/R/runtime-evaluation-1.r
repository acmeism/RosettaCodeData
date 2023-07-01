expr1 <- quote(a+b*c)
expr2 <- parse(text="a+b*c")[[1]]
expr3 <- call("+", quote(`a`), call("*", quote(`b`), quote(`c`)))
