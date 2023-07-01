const Nr = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
const Nc = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2]

const N0 = zeros(Int, 85)
const N2 = zeros(UInt64, 85)
const N3 = zeros(UInt8, 85)
const N4 = zeros(Int, 85)
const i = 1
const g = 8
const ee = 2
const l = 4
const _n = Vector{Int32}([0])

function fY(n::Int)
    if N2[n + 1] == UInt64(0x123456789abcdef0)
        return true, n
    end
    if N4[n + 1] <= _n[1]
        return fN(n)
    end
    false, n
end

function fZ(w, n)
    if w & i > 0
        n = fI(n)
        (y, n) = fY(n)
        if y return (true, n) end
        n -= 1
    end
    if w & g > 0
        n = fG(n)
        (y, n) = fY(n)
        if y return (true, n) end
        n -= 1
    end
    if w & ee > 0
        n = fE(n)
        (y, n) = fY(n)
        if y return (true, n) end
        n -= 1
    end
    if w & l > 0
        n = fL(n)
        (y, n) = fY(n)
        if y return (true, n) end
        n -= 1
    end
    false, n
end

function fN(n::Int)
    x = N0[n + 1]
    y = UInt8(N3[n + 1])
    if x == 0
        if y == UInt8('l')
            return fZ(i, n)
        elseif y == UInt8('u')
            return fZ(ee, n)
        else
            return fZ(i + ee, n)
        end
    elseif x == 3
        if y == UInt8('r')
            return fZ(i, n)
        elseif y == UInt8('u')
            return fZ(l, n)
        else
            return fZ(i + l, n)
        end
    elseif x == 1 || x == 2
        if y == UInt8('l')
            return fZ(i + l, n)
        elseif y == UInt8('r')
            return fZ(i + ee, n)
        elseif y == UInt8('u')
            return fZ(ee + l, n)
        else
            return fZ(l + ee + i, n)
        end
    elseif x == 12
        if y == UInt8('l')
            return fZ(g, n)
        elseif y == UInt8('d')
            return fZ(ee, n)
        else
            return fZ(ee + g, n)
        end
    elseif x == 15
        if y == UInt8('r')
            return fZ(g, n)
        elseif y == UInt8('d')
            return fZ(l, n)
        else
            return fZ(g + l, n)
        end
    elseif x == 13 || x == 14
        if y == UInt8('l')
            return fZ(g + l, n)
        elseif y == UInt8('r')
            return fZ(ee + g, n)
        elseif y == UInt8('d')
            return fZ(ee + l, n)
        else
            return fZ(g + ee + l, n)
        end
    elseif x == 4 || x == 8
        if y == UInt8('l')
            return fZ(i + g, n)
        elseif y == UInt8('u')
            return fZ(g + ee, n)
        elseif y == UInt8('d')
            return fZ(i + ee, n)
        else
            return fZ(i + g + ee, n)
        end
    elseif x == 7 || x == 11
        if y == UInt8('d')
            return fZ(i + l, n)
        elseif y == UInt8('u')
            return fZ(g + l, n)
        elseif y == UInt8('r')
                return fZ(i + g, n)
        else
            return fZ(i + g + l, n)
        end
    else
        if y == UInt8('d')
            return fZ(i + ee + l, n)
        elseif y == UInt8('l')
                return fZ(i + g + l, n)
        elseif y == UInt8('r')
            return fZ(i + g + ee, n)
        elseif y == UInt8('u')
            return fZ(g + ee + l, n)
        else
            return fZ(i + g + ee + l, n)
        end
    end
end

function fI(n)
    gg = (11 - N0[n + 1]) * 4
    a = N2[n + 1] & (UInt64(0xf) << UInt(gg))
    N0[n + 2] = N0[n + 1] + 4
    N2[n + 2] = N2[n + 1] - a + (a << 16)
    N3[n + 2] = UInt8('d')
    N4[n + 2] = N4[n + 1]
    cond = Nr[(a >> gg) + 1] <= div(N0[n + 1], 4)
    if !cond
        N4[n + 2] += 1
    end
    n += 1
    n
end

function fG(n)
    gg = (19 - N0[n + 1]) * 4
    a = N2[n + 1] & (UInt64(0xf) << UInt(gg))
    N0[n + 2] = N0[n + 1] - 4
    N2[n + 2] = N2[n + 1] - a + (a >> 16)
    N3[n + 2] = UInt8('u')
    N4[n + 2] = N4[n + 1]
    cond = Nr[(a >> gg) + 1] >= div(N0[n + 1], 4)
    if !cond
        N4[n + 2] += 1
    end
    n += 1
    n
end

function fE(n)
    gg = (14 - N0[n + 1]) * 4
    a = N2[n + 1] & (UInt64(0xf) << UInt(gg))
    N0[n + 2] = N0[n + 1] + 1
    N2[n + 2] = N2[n + 1] - a + (a << 4)
    N3[n + 2] = UInt8('r')
    N4[n + 2] = N4[n + 1]
    cond = Nc[(a >> gg) + 1] <= N0[n + 1] % 4
    if !cond
        N4[n + 2] += 1
    end
    n += 1
    n
end

function fL(n)
    gg = (16 - N0[n + 1]) * 4
    a = N2[n + 1] & (UInt64(0xf) << UInt(gg))
    N0[n + 2] = N0[n + 1] - 1
    N2[n + 2] = N2[n + 1] - a + (a >> 4)
    N3[n + 2] = UInt8('l')
    N4[n + 2] = N4[n + 1]
    cond = Nc[(a >> gg) + 1] >= N0[n + 1] % 4
    if !cond
        N4[n + 2] += 1
    end
    n += 1
    n
end

function solve(n)
    ans, n = fN(n)
    if ans
        println("Solution found in $n moves: ")
        for ch in N3[2:n+1] print(Char(ch)) end; println()
    else
        println("next iteration, _n[1] will be $(_n[1] + 1)...")
        n = 0; _n[1] += 1; solve(n)
    end
end

run() = (N0[1] = 8; _n[1] = 1; N2[1] = 0xfe169b4c0a73d852; solve(0))
run()
