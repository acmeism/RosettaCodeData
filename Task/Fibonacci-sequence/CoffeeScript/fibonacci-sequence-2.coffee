fib_iter = (n) ->
    if n < 2
        return n
    [prev, curr] = 0, 1
    for i in [1..n]
       [prev, curr] = [curr, curr + prev]
    return curr
