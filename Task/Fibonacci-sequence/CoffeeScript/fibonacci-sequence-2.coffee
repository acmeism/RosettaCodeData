fib_iter = (n) ->
    return n if n < 2
    [prev, curr] = [0, 1]
    [prev, curr] = [curr, curr + prev] for i in [1..n]
    curr
