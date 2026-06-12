const Cube = Vector{Vector{Vector{Int}}}
const Mat = Vector{Vector{Int}}

function reduced(m::Mat)
    n = length(m)
    r = deepcopy(m)
    for j in 1:n-1
        if r[1][j] != j
            for k in j+1:n
                if r[1][k] == j
                    for i in 1:n
                        r[i][j], r[i][k] = r[i][k], r[i][j]
                    end
                    break
                end
            end
        end
    end
    for i in 2:n-1
        if r[i][1] != i
            for k in i+1:n
                if r[k][1] == i
                    for j in 1:n
                        r[i][j], r[k][j] = r[k][j], r[i][j]
                    end
                    break
                end
            end
        end
    end
    return r
end

""" print matrix as small integers, no punctuation """
function print_matrix(m::Mat)
    n = length(m)
    padding = max(2, Int(ceil(log(10, n+1))) + 1)
    for i in 1:n
        for j in 1:n
            print(lpad(m[i][j], padding))
        end
        println()
    end
    println()
end

function shuffle_cube(c::Cube)
    n = length(c)
    proper = true
    rx, ry, rz = 0, 0, 0
    while true
        rx, ry, rz = rand(1:n, 3)
        c[rx][ry][rz] == 0 && break
    end
    while true
        ox = something(findfirst(i -> c[i][ry][rz] == 1, 1:n), n)
        oy = something(findfirst(i -> c[rx][i][rz] == 1, 1:n), n)
        oz = something(findfirst(i -> c[rx][ry][i] == 1, 1:n), n)
        if !proper
            rand() < 1/2 && (ox = something(findlast(i -> c[i][ry][rz] == 1, 1:n), n))
            rand() < 1/2 && (oy = something(findlast(i -> c[rx][i][rz] == 1, 1:n), n))
            rand() < 1/2 && (oz = something(findlast(i -> c[rx][ry][i] == 1, 1:n), n))
        end

        c[rx][ry][rz] += 1
        c[rx][oy][oz] += 1
        c[ox][ry][oz] += 1
        c[ox][oy][rz] += 1

        c[rx][ry][oz] -= 1
        c[rx][oy][rz] -= 1
        c[ox][ry][rz] -= 1
        c[ox][oy][oz] -= 1

        if c[ox][oy][oz] < 0
            rx, ry, rz = ox, oy, oz
            proper = false
        else
            break
        end
    end
end

function matrix(c::Cube)::Mat
    n = length(c)
    m = [[0 for i in 1:n] for j in 1:n]
    for i in 1:n, j in 1:n
        for k in 1:n
            if c[i][j][k] != 0
                m[i][j] = k
                break
            end
        end
    end
    return m
end

function cube(from, n)
    c = [[[0 for i in 1:n] for j in 1:n] for k in 1:n]
    for i in 1:n, j in 1:n
        k = (from isa Nothing) ? mod1(i + j, n) : from[i][j]
        c[i][j][k] = 1
    end
    return c
end

function testJacobsenMatthews()
    # part 1
    println("PART 1: 10,000 latin Squares of order 4 in reduced form:\n")
    from = [[1, 2, 3, 4], [2, 1, 4, 3], [3, 4, 1, 2], [4, 3, 2, 1]]
    freqs4 = Dict{Array, Int}()
    c = cube(from, 4)
    for i in 1:10000
        shuffle_cube(c)
        m = matrix(c)
        rm = reduced(m)
        n = get!(freqs4, rm, 0)
        freqs4[rm] = n + 1
    end
    for (a, freq) in freqs4
        print_matrix(a)
        println("Occurs $freq times\n")
    end

    # part 2
    println("\nPART 2: 10,000 latin squares of order 5 in reduced form:\n")
    from = [[1, 2, 3, 4, 5], [2, 3, 4, 5, 1], [3, 4, 5, 1, 2], [4, 5, 1, 2, 3], [5, 1, 2, 3, 4]]
    freqs5 = Dict{Array, Int}()
    c = cube(from, 5)
    for i in 1:10000
        shuffle_cube(c)
        m = matrix(c)
        rm = reduced(m)
        n = get!(freqs5, rm, 0)
        freqs5[rm] = n + 1
    end
    for (i, freq) in enumerate(sort(collect(values(freqs5))))
        i > 1 && (print(", "); (i - 1) % 8 == 0 && println())
        print(lpad(i, 2), "(", lpad(freq, 3), ")")
    end
    println("\n")

    # part 3
    println("\nPART 3: 750 latin squares of order 42, showing the last one:\n")
    m42 = [[0 for i in 1:42] for j in 1:42]
    c = cube(nothing, 42)
    for i in 1:750
        shuffle_cube(c)
        i == 750 && (m42 = matrix(c))
    end
    print_matrix(m42)

    # part 4
    println("\nPART 4: 1000 latin squares of order 256:\n")
    @time begin
        c = cube(nothing, 256)
        for i in 1:1000
            shuffle_cube(c)
        end
    end
end

testJacobsenMatthews()
