function gauss(m)
    n, p = length(m), length(m[1])
    for i in 1:n
        _, k = findmax(map(x -> abs(m[x][i]), i:n)) .+ (i - 1)
        m[i], m[k] = m[k], m[i]
        t = 1 // m[i][i]
        for j in i+1:p
            m[i][j] *= t
        end
        for j in i+1:n
            t = m[j][i]
            for k in i+1:p
                m[j][k] -= t * m[i][k]
            end
        end
    end
    for i in n:-1:1, j in 1:i-1; m[j][end] -= m[j][i] * m[i][end]; end
    return [row[end] for row in m]
end

function network(n, k0, k1, s)
    m = [[0//1 for i in 1:n + 1] for j in 1:n]
    resistors = split(s, "|")
    for resistor in resistors
        astr, bstr, rstr = split(resistor, " ")
        a, b, r = parse(Int, astr), parse(Int, bstr), 1 // parse(Int, rstr)
        m[a + 1][a + 1] += r
        m[b + 1][b + 1] += r
        if a > 0; m[a + 1][b + 1] -= r end
        if b > 0; m[b + 1][a + 1] -= r end
    end
    m[k0+1][k0+1] = m[k1+1][end] = 1 // 1
    return gauss(m)[k1+1]
end

@assert(10     == network(7,0,1,"0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8"))
@assert(3//2   == network(3*3,0,3*3-1,"0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1"))
@assert(13//7 == network(4*4,0,4*4-1,"0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1"))
@assert(180   == network(4,0,3,"0 1 150|0 2 50|1 3 300|2 3 250"))
