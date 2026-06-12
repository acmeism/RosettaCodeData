"""
Solution of an m x n linear Diophantine system A*x = b using LLL reduction.
Ref: G. Havas, B. Majewski, K. Matthews,
    'Extended gcd and Hermite normal form algorithms via lattice basis reduction,'
    Experimental Mathematics 7 (1998), no.2, pp.125-136
"""

using OffsetArrays
using Printf

const ECHO = false

# The complexity of the algorithm increases with alpha,
# as does the quality guarantee on the lattice basis vectors.
# So we specify 1/4 < alpha == ALN / ALD == 80 / 81 < 1
const ALN = 80
const ALD = 81

# The FreeBASIC code uses copious globals, which are discouraged in Julia.
# So, wrap the translated Basic code in a "let" statement to avoid actual globals.
let
    # variables for rows, columns, and indices
    m1, mn, nx, m, n, c1, c2 = 0, 0, 0, 0, 0, 0, 0

    # Gram-Schmidt coefficients la, d and work matrix a, which use a wierd and
    # inconsistent basis in FreeBASIC code: 0 basis for la and a and -1 basis for d
    la = OffsetArray(Matrix{Float64}(undef, 0, 0))
    d = OffsetArray(Vector{Float64}())
    a = OffsetArray(Matrix{Float64}(undef, 0, 0))

    """ Input complex constant, read powers into A """
    function inpconst(pr::Int, lines = String[])
        m2 = m1 + 1
        if isempty(lines)
            print(" a + bi: ")
            g = readline()
        else
            g = popfirst!(lines)
        end
        xy = strip.(split(g, "+"))
        x = parse(Float64, xy[begin])
        y = length(xy) == 2 ? parse(Float64, xy[begin+1]) : 0.0
        println(x, y == 0 ? "" : "+ $y*i")

        # Fudge factor 1
        a[0, m1] = 1
        # c^0
        p = 10.0^pr
        a[1, m1] = p
        q = 0.0

        # Compute powers
        for r in 2:m-1
            t = p
            p = p * x - q * y
            q = t * y + q * x
            a[r, m1] = round(p)
            a[r, m2] = round(q)
        end
    end

    """ Input A and b """
    function inpsys(lines = String[])
        sw = false
        for r in 0:n-1
            isempty(lines) && print(" row A", r + 1, " and b", r + 1, " ")
            g = isempty(lines) ? strip(readline()) : strip(popfirst!(lines))
            # Reject fractional coefficients
            sw |= occursin(r"[./]", g)

            # Parse row
            s = 0
            for token in split(g, r"[ |]")
                if !isempty(token)
                    if s > m + 1
                        println("Ignoring extra characters.")
                        break
                    end
                    a[s, m1+r] = parse(Float64, token)
                    s += 1
                end
            end
        end
        sw && println("illegal input")
        return sw
    end

    """ Print row r """
    function prow(r, p, l, io = stdout)
        for s in 0:mn
            s == m1 && print(io, " |")
            print(io, " "^(p[s] - l[r, s] + 1), @sprintf("% .0lf", a[r, s]))
        end
    end

    """ Print matrix A """
    function printm(sw::Bool)
        l = OffsetArray(zeros(Int, m + 1, mn + 1), 0:m, 0:mn)
        p = OffsetArray(ones(Int, mn + 1), 0:mn)
        for s in 0:mn
            for r in 0:m
                l[r, s] = length(string(Int(abs(a[r, s]))))
                p[s] = max(p[s], l[r, s])
            end
        end

        if sw
            println("P | Hnf")
            # Evaluate
            k = 0
            for r in 0:m
                if a[r, mn] != 0
                    k = r
                    break
                end
            end
            sw = a[k, mn] == 1
            for s in m1:mn-1
                sw &= a[k, s] == 0
            end
            g = sw ? "  -solution" : "   inconsistent"
            for s in 0:m-1
                sw &= a[k, s] == 0
            end
            if sw
                g = "" # trivial
            end

            # Hnf and solution
            for r in m:-1:k
                prow(r, p, l)
                println(r == k ? g : "")
            end
            # Null space with lengths squared
            for r in 0:k-1
                prow(r, p, l)
                q = 0.0
                for s in 0:m-1
                    q += a[r, s] * a[r, s]
                end
                println("   (", Int(q), ")")
            end
        else
            println("I | Ab~")
            for r ∈ 0:m
                prow(r, p, l)
                println()
            end
        end
    end


    """ HMM algorithm 4, negate row t portion """
    function minus(t::Int)
        for s in 0:mn
            a[t, s] = -a[t, s]
        end
        for r in 1:m
            for s in 0:r-1
                if r == t || s == t
                    la[r, s] = -la[r, s]
                end
            end
        end
    end

    """ HMM algorithm 4, LLL reduce rows k portion """
    function reduce(k::Int, t::Int)
        c1 = nx
        c2 = nx
        # Pivot elements Ab~ in rows t and k
        for s in m1:mn
            if a[t, s] != 0
                c1 = s
                break
            end
        end
        for s in m1:mn
            if a[k, s] != 0
                c2 = s
                break
            end
        end

        q = 0.0
        if c1 < nx
            if a[t, c1] < 0
                minus(t)
            end
            q = floor(a[k, c1] / a[t, c1])
        else
            lk = la[k, t]
            if 2 * abs(lk) > d[t]
                q = round(lk / d[t])
            end
        end

        if q != 0
            sx = c1 == nx ? m : mn
            # Reduce row k
            for s in 0:sx
                a[k, s] -= q * a[t, s]
            end
            la[k, t] -= q * d[t]
            for s in 0:t-1
                la[k, s] -= q * la[t, s]
            end
        end
    end

    """ HMM algorithm 4, exchange rows k and k-1 """
    function swop(k::Int)
        t = k - 1
        for s in 0:mn
            a[k, s], a[t, s] = a[t, s], a[k, s]
        end
        for s in 0:t-1
            la[k, s], la[t, s] = la[t, s], la[k, s]
        end

        # Update Gram coefficients
        lk = la[k, t]
        db = (d[t-1] * d[k] + lk * lk) / d[t]
        for r in k+1:m
            lr = la[r, k]
            la[r, k] = (d[k] * la[r, t] - lk * lr) / d[t]
            la[r, t] = (db * lr + lk * la[r, k]) / d[k]
        end
        d[t] = db
    end

    """ main limiting sequence """
    function main(sw::Int, lines = String[])
        if sw != 0
            inpconst(sw, lines)
        else
            inpsys(lines) && return
        end
        # Augment Ab~ with column e_m
        a[m, mn] = 1
        # Prefix standard basis
        for i in 0:m
            a[i, i] = 1
        end
        # Gram sub-determinants
        for i in -1:m
            d[i] = 1
        end

        ECHO && printm(false)

        k = 1
        tl = 0
        while k <= m
            t = k - 1
            # Partial size reduction
            reduce(k, t)

            sw_flag = (c1 == nx && c2 == nx)
            if sw_flag
                lk = la[k, t]
                # Lovasz condition
                db = d[t-1] * d[k] + lk * lk
                sw_flag = db * ALD < d[t] * d[t] * ALN
            end

            if sw_flag || (c1 <= c2 && c1 < nx)
                # Test recommends a swap
                swop(k)
                if k > 1
                    k -= 1
                end
            else
                # Complete size reduction
                for i in t-1:-1:0
                    reduce(k, i)
                end
                k += 1
            end
            tl += 1
        end

        printm(true)
        println("loop ", tl)
    end

    """ Driver, input and output """
    function iodriver(text = "")
        sw = 0
        lines = String[]
        function run_input()
            # Set indices and allocate
            if sw != 0
                sw = n - 1
                n = 2
                m += 2
            end
            m1 = m + 1
            mn = m1 + n
            nx = mn + 1
            # rather than fixing up abused array indices here, we use OffsetArrays to accommodate
            # the weirdness of the array basis choices in the original example's FreeBASIC code
            la = OffsetArray(zeros(Float64, m + 1, m + 1), 0:m, 0:m)
            d = OffsetArray(zeros(Float64, m + 2), -1:m)  # For indices -1 to m
            a = OffsetArray(zeros(Float64, m + 1, mn + 1), 0:m, 0:mn)

            isempty(lines) && print("\033[2J")  # Clear screen
            main(sw, lines)
            println()
        end
        if isempty(text)
            while true
                println()
                sw = 0
                while true
                    print(" rows ")
                    g = strip(readline())
                    if !startswith(g, "'")
                        break
                    end
                    println(g)
                    sw = sw | Int(occursin("const", g))
                end
                n = tryparse(Int, g)
                if isnothing(n) || n < 1
                    break
                end
                print(" cols ")
                g = strip(readline())
                m = tryparse(Int, g)
                if isnothing(m) || m < 1
                    for _ ∈ 1:n
                        readline()
                    end
                    continue
                end
                run_input()
            end
        else
            append!(lines, strip.(split(text, "\n")))
            while !isempty(lines)
                println()
                sw = 0
                while true
                    g = popfirst!(lines)
                    if !startswith(g, "'")
                        break
                    end
                    println(g)
                    sw = sw | Int(occursin("const", g))
                end
                n = tryparse(Int, g)
                if isnothing(n) || n < 1
                    break
                end
                g = popfirst!(lines)
                m = tryparse(Int, g)
                if isnothing(m) || m < 1
                    for _ in 1:n
                        popfirst!(lines)
                    end
                    continue
                end
                run_input()
            end
        end
    end

    # test the first and last 5 examples
    testtext = """
    'five base cases
    'no integral solution
    2
    2
    2 0| 1
    2 1| 2
    'indeterminate
    2
    3
    1  3  5
    4  6  8
    'singular square
    3
    3
    1  7  4
    2  8  5
    3  9  6
    'overdetermined
    3
    2
    2  1| 2
    6  5| 2
    7  6| 2
    'square
    3
    3
    2 -3  4| 9
    5  6  7| 3
    8  9 10| 3
    'Hnf(A) with Aij = i^3 * j^2 + i + j (example 7.4)
    10
    10
    3  11   31   69   131   223   351   521   739   1011
    7  36  113  262   507   872  1381  2058  2927   4012
    13  77  249  583  1133  1953  3097  4619  6573   9013
    21 134  439 1032  2009  3466  5499  8204 11677  16014
    31 207  683 1609  3135  5411  8587 12813 18239  25015
    43 296  981 2314  4511  7788 12361 18446 26259  36016
    57 401 1333 3147  6137 10597 16821 25103 35737  49017
    73 522 1739 4108  8013 13838 21967 32784 46673  64018
    91 659 2199 5197 10139 17511 27799 41489 59067  81019
    111 812 2713 6414 12515 21616 34317 51218 72919 100020
    'Gauss x*atan(1/239) + y*atan(1/57) + z*atan(1/18) = pi/4
    '(fudge factor -1 to absorb round-off error
    ' ignore the corresponding vector entry x1)
    1
    4
    -1 0041841 0175421 0554985| 7853982
    'search for polynomial coefficients
    'const sqrt(2) + i
    4
    4
    1.41421356 + 1
    'const 3^(1/3) + sqrt(2)
    11
    6
    2.8564631326805
    'some constant
    12
    9
    -1.4172098692728
    0
    0
    """

    iodriver(testtext)

end # of let
