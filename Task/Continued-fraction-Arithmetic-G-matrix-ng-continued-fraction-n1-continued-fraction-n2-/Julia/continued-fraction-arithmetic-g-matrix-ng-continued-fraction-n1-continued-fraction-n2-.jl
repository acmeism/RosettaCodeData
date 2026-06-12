abstract type MatrixNG end

mutable struct NG4 <: MatrixNG
    cfn::Int
    thisterm::Int
    haveterm::Bool
    a1::Int
    a::Int
    b1::Int
    b::Int
    NG4(a1, a, b1, b) = new(0, 0, false, a1, a, b1, b)
end

mutable struct NG8 <: MatrixNG
    cfn::Int
    thisterm::Int
    haveterm::Bool
    a12::Int
    a1::Int
    a2::Int
    a::Int
    b12::Int
    b1::Int
    b2::Int
    b::Int
    NG8(a12, a1, a2, a, b12, b1, b2, b) = new(0, 0, false, a12, a1, a2, a, b12, b1, b2, b)
end

function needterm(m::NG4)::Bool
    m.b1 == m.b == 0 && return false
    (m.b1 == 0 || m.b == 0) && return true
    (m.thisterm = m.a ÷ m.b) != m.a1 ÷ m.b1 && return true
    m.a, m.b = m.b, m.a - m.b * m.thisterm
    m.a1, m.b1, m.haveterm = m.b1, m.a1 - m.b1 * m.thisterm, true
    return false
end

consumeterm(m::NG4) = (m.a = m.a1; m.b = m.b1)
function consumeterm(m::NG4, n)
    m.a, m.a1 = m.a1, m.a + m.a1 * n
    m.b, m.b1 = m.b1, m.b + m.b1 * n
end

function needterm(m::NG8)::Bool
    m.b1 == m.b == m.b2 == m.b12 == 0 && return false
    if m.b == 0
        m.cfn = m.b2 == 0 ? 0 : 1
        return true
    elseif m.b2 == 0
        m.cfn = 1
        return true
    elseif m.b1 == 0
        m.cfn = 0
        return true
    end
    ab = m.a / m.b
    a1b1 = m.a1 / m.b1
    a2b2 = m.a2 / m.b2

    if m.b12 == 0
        m.cfn = abs(a1b1 - ab) > abs(a2b2 - ab) ? 0 : 1
        return true
    end
    m.thisterm = m.a ÷ m.b
    if m.thisterm == m.a1 ÷ m.b1 == m.a2 ÷ m.b2 == m.a12 ÷ m.b12
        m.a, m.b = m.b, m.a - m.b * m.thisterm
        m.a1, m.b1 = m.b1, m.a1 - m.b1 * m.thisterm
        m.a2, m.b2 = m.b2, m.a2 - m.b2 * m.thisterm
        m.a12, m.b12, m.haveterm = m.b12, m.a12 - m.b12 * m.thisterm, true
        return false
    end
    m.cfn = abs(a1b1 - ab) > abs(a2b2 - ab) ? 0 : 1
    return true
end

function consumeterm(m::NG8)
    if m.cfn == 0
        m.a, m.a2 = m.a1, m.a12
        m.b, m.b2 = m.b1, m.b12
    else
        m.a, m.a1 = m.a2, m.a12
        m.b, m.b1 = m.b2, m.b12
    end
end
function consumeterm(m::NG8, n)
    if m.cfn == 0
        m.a, m.a1 = m.a1, m.a + m.a1 * n
        m.a2, m.a12 = m.a12, m.a2 + m.a12 * n
        m.b, m.b1 = m.b1, m.b + m.b1 * n
        m.b2, m.b12 = m.b12, m.b2 + m.b12 * n
    else
        m.a, m.a2 = m.a2, m.a + m.a2 * n
        m.a1, m.a12 = m.a12, m.a1 + m.a12 * n
        m.b, m.b2 = m.b2, m.b + m.b2 * n
        m.b1, m.b12 = m.b12, m.b1 + m.b12 * n
    end
end

abstract type ContinuedFraction end

mutable struct R2cf <: ContinuedFraction
    n1::Int
    n2::Int
end

function nextterm(x::R2cf)
    term = x.n1 ÷ x.n2
    x.n1, x.n2 = x.n2, x.n1 - term * x.n2
    return term
end

moreterms(x::R2cf) = abs(x.n2) > 0

mutable struct NG <: ContinuedFraction
    ng::MatrixNG
    n::Vector{ContinuedFraction}
end
NG(ng, n1::ContinuedFraction) = NG(ng, [n1])
NG(ng, n1::ContinuedFraction, n2) = NG(ng, [n1, n2])
nextterm(x::NG) = (x.ng.haveterm = false; x.ng.thisterm)

function moreterms(x::NG)::Bool
    while needterm(x.ng)
        if moreterms(x.n[x.ng.cfn + 1])
            consumeterm(x.ng, nextterm(x.n[x.ng.cfn + 1]))
        else
            consumeterm(x.ng)
        end
    end
    return x.ng.haveterm
end

function testcfs()
    function test(desc, cfs)
        println("TESTING -> $desc")
        for cf in cfs
            while moreterms(cf)
                print(nextterm(cf), " ")
            end
            println()
        end
        println()
    end

    a  = NG8(0, 1, 1, 0, 0, 0, 0, 1)
    n2 = R2cf(22, 7)
    n1 = R2cf(1, 2)
    a3 = NG4(2, 1, 0, 2)
    n3 = R2cf(22, 7)
    test("[3;7] + [0;2]", [NG(a, n1, n2), NG(a3, n3)])

    b  = NG8(1, 0, 0, 0, 0, 0, 0, 1)
    b1 = R2cf(13, 11)
    b2 = R2cf(22, 7)
    test("[1;5,2] * [3;7]", [NG(b, b1, b2), R2cf(286, 77)])

    c = NG8(0, 1, -1, 0, 0, 0, 0, 1)
    c1 = R2cf(13, 11)
    c2 = R2cf(22, 7)
    test("[1;5,2] - [3;7]", [NG(c, c1, c2), R2cf(-151, 77)])

    d = NG8(0, 1, 0, 0, 0, 0, 1, 0)
    d1 = R2cf(22 * 22, 7 * 7)
    d2 = R2cf(22, 7)
    test("Divide [] by [3;7]", [NG(d, d1, d2)])

    na = NG8(0, 1, 1, 0, 0, 0, 0, 1)
    a1 = R2cf(2, 7)
    a2 = R2cf(13, 11)
    aa = NG(na, a1, a2)
    nb = NG8(0, 1, -1, 0, 0, 0, 0, 1)
    b3 = R2cf(2, 7)
    b4 = R2cf(13, 11)
    bb = NG(nb, b3, b4)
    nc = NG8(1, 0, 0, 0, 0, 0, 0, 1)
    desc = "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
    test(desc, [NG(nc, aa, bb), R2cf(-7797, 5929)])
end

testcfs()
