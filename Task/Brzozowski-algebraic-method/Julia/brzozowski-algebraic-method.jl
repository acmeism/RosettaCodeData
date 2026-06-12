import Base.==
import Base.string

abstract type RE end

struct Empty <: RE end
string(e::Empty) = "0"
const empty = Empty()
==(e1::Empty, e2::Empty) = true

struct Epsilon <: RE end
string(e::Epsilon) = "1"
const epsilon = Epsilon()
==(e1::Epsilon, e2::Epsilon) = true

struct Car <: RE
    c::Any
end
string(c1::Car) = c1.c
==(c1::Car, c2::Car) = c1.c isa typeof(c2.c) && c1.c == c2.c

struct Union <: RE
    e::Any
    f::Any
end
string(u::Union) = string(u.e) * "+" * string(u.f)
==(u1::Union, u2::Union) =
    u1.e isa typeof(u2.e) && u1.e == u2.e && u1.f isa typeof(u2.f) && u1.f == u2.f

struct Concat <: RE
    e::Any
    f::Any
end
string(c::Concat) = "(" * string(c.e) * ")(" * string(c.f) * ")"
==(c1::Concat, c2::Concat) =
    c1.e isa typeof(c2.e) && c1.e == c2.e && c1.f isa typeof(c2.f) && c1.f == c2.f

struct Star <: RE
    e::Any
end
string(s::Star) = "(" * string(s.e) * ")*"
==(s1::Star, s2::Star) = s1.e isa typeof(s2.e) && s1.e == s2.e

function simple_re(e)
    function simple(e::Union)
        e_e = simple(e.e)
        e_f = simple(e.f)
        e_e isa typeof(e_f) && e_e == e_f && return e_e
        e_e isa Union && return simple(Union(e_e.e, Union(e_e.f, e_f)))
        e_e isa Empty && return e_f
        e_f isa Empty && return e_e
        return Union(e_e, e_f)
    end
    function simple(e::Concat)
        e_e = simple(e.e)
        e_f = simple(e.f)
        e_e isa Epsilon && return e_f
        e_f isa Epsilon && return e_e
        (e_e isa Empty || e_f isa Empty) && return empty
        e_e isa Concat && return simple(Concat(e_e.e, Concat(e_e.f, e_f)))
        return Concat(e_e, e_f)
    end
    function simple(e::Star)
        e_e = simple(e.e)
        (e_e isa Empty || e_e isa Epsilon) && return epsilon
        return Star(e_e)
    end
    simple(e) = e # default

    while true
        prevE = e
        e = simple(e)
        e isa typeof(prevE) && e == prevE && break
    end
    return e
end

function brzozowski!(a, b)
    for n = length(a):-1:1
        a_nn = a[n][n]
        b[n] = Concat(Star(a_nn), b[n])
        for j = 1:n-1
            a[n][j] = Concat(Star(a_nn), a[n][j])
        end
        for i = 1:n-1
            b[i] = Union(b[i], Concat(a[i][n], b[n]))
            for j = 1:n-1
                a[i][j] = Union(a[i][j], Concat(a[i][n], a[n][j]))
            end
        end
        for i = 1:n-1
            a[i][n] = empty
        end
    end
    return b[begin]
end

const a =
    [[empty, Car("a"), Car("b")], [Car("b"), empty, Car("a")], [Car("a"), Car("b"), empty]]
const b = [epsilon, empty, empty]
const re = brzozowski!(a, b)
println(string(re))
println("\nwhich simplifies to:\n")
println(string(simple_re(re)))
