wheel235 = () ->
    yield 2
    yield 3
    yield 5
    a = 1
    i = 0
    wheel = [6, 4, 2, 4, 2, 4, 6, 2]
    loop
        a += wheel[i]
        yield a
        i = (i + 1) & 7

gpf = (n) ->
    w = wheel235()
    d = w.next().value
    until d*d > n
        if n % d is 0
            n //= d
        else
            d = w.next().value
    n

console.log "The largest prime factor of 600,851,475,143 is #{gpf(600_851_475_143)}"
