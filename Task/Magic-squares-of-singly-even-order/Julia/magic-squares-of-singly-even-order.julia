function oddmagicsquare(order)
    if iseven(order)
        order += 1
    end
    q = zeros(Int, (order, order))
    p = 1
    i = div(order, 2) + 1
    j = 1
    while p <= order * order
        q[i, j] = p
        ti = (i + 1 > order) ? 1 : i + 1
        tj = (j - 1 < 1) ? order : j - 1
        if q[ti, tj] != 0
            ti = i
            tj = j + 1
        end
        i = ti
        j = tj
        p = p + 1
    end
    q, order
end

function singlyevenmagicsquare(order)
    if isodd(order)
        order += 1
    end
    if order % 4 == 0
        order += 2
    end
    q = zeros(Int, (order, order))
    z = div(order, 2)
    b = z * z
    c = 2 * b
    d = 3 * b
    sq, ord = oddmagicsquare(z)

    for j in 1:z, i in 1:z
        a = sq[i, j]
        q[i, j] = a
        q[i + z, j + z] = a + b
        q[i + z, j] = a + c
        q[i, j + z] = a + d
    end
    lc = div(z, 2)
    rc = lc - 1
    for j in 1:z, i in 1:order
        if i <= lc || i > order - rc || (i == lc && j == lc)
            if i != 0 || j != lc + 1
                t = q[i, j]
                q[i, j] = q[i, j + z]
                q[i, j + z] = t
            end
        end
    end
    q, order
end

function check(q)
    side = size(q)[1]
    sums = Vector{Int}()
    for n in 1:side
        push!(sums, sum(q[n, :]))
        push!(sums, sum(q[:, n]))
    end
    println(all(x->x==sums[1], sums) ?
        "Checks ok: all sides add to $(sums[1])." : "Bad sum.")
end

function display(q)
    r, c = size(q)
    for i in 1:r, j in 1:c
        nstr = lpad(string(q[i, j]), 4)
        print(j % c > 0 ? nstr : "$nstr\n")
    end
end

for o in (6, 10)
    println("\nWith order $o:")
    msq = singlyevenmagicsquare(o)[1]
    display(msq)
    check(msq)
end
