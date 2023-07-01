pascal = () ->
    a = []
    return () ->
        if a.length is 0 then a = [1]
        else
            b = (a[i] + a[i+1] for i in [0 ... a.length - 1])
            a = [1].concat(b).concat [1]

show = (a) ->
    show_x = (e) ->
        switch e
            when 0 then ""
            when 1 then "x"
            else "x^#{e}"

    degree = a.length - 1
    str = "(x - 1)^#{degree} ="
    sgn = 1

    for i in [0...a.length]
        str += ' ' + (if sgn > 0 then "+" else "-") + ' ' + a[i] + show_x(degree - i)
        sgn = -sgn

    return str

primerow = (row) ->
    degree = row.length - 1
    row[1 ... degree].every (x) -> x % degree is 0

p = pascal()
console.log show p() for i in [0..7]

p = pascal()
p(); p()  # skip 0 and 1

primes = (i+1 for i in [1..49] when primerow p())

console.log ""
console.log "The primes upto 50 are: #{primes}"
