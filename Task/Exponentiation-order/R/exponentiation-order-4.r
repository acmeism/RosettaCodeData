inputs <- alist(5^3^2, (5^3)^2, 5^(3^2), 5**3**2, (5**3)**2, 5**(3**2))
invisible(sapply(inputs, function(x) cat(deparse(x), "returns: ", eval(x), "\n")))
