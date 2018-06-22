fib_ana = (n) ->
    sqrt = Math.sqrt
    phi = ((1 + sqrt(5))/2)
    Math.round((Math.pow(phi, n)/sqrt(5)))
