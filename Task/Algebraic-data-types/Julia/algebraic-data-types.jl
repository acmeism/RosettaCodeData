import Base.length

abstract type AbstractColoredNode end

struct RedNode <: AbstractColoredNode end; const R = RedNode()
struct BlackNode <: AbstractColoredNode end; const B = BlackNode()
struct Empty end; const E = Empty()
length(e::Empty) = 1

function balance(b::BlackNode, v::Vector, z, d)
    if v[1] == R
        if length(v[2]) == 4 && v[2][1] == R
            return [R, [B, v[2][2], v[2][3], v[2][4]], v[3], [B, v[4], z, d]]
        elseif length(v[4]) == 4 && v[4][1] == R
            return [R, [B, v[2], v[3], v[4][2]], v[4][3], [B, v[4][4], z, d]]
        end
    end
    [b, v, z, d]
end

function balance(b::BlackNode, a, x, v::Vector)
    if v[1] == R
        if length(v[2]) == 4 && v[2][1] == R
            return [R, [B, a, x, v[2][2]], v[2][3], [B, v[2][4], v[3], v[4]]]
        elseif length(v[4]) == 4 && v[4][1] == R
            return [R, [B, a, x, v[2]], v[3], [B, v[4][2], v[4][3], v[4][4]]]
        end
    end
    [b, a, x, v]
end

function balance(b::BlackNode, a::Vector, x, v::Vector)
    if v[1] == R
        if length(v[2]) == 4 && v[2][1] == R
            return [R, [B, a, x, v[2][2]], v[2][3], [B, v[2][4], v[3], v[4]]]
        elseif length(v[4]) == 4 && v[4][1] == R
            return [R, [B, a, x, v[2]], v[3], [B, v[4][2], v[4][3], v[4][4]]]
        end
    end
    [b, a, x, v]
end

balance(node, l, a, r) = [node, l, a, r]

function ins(v::Vector, x::Number)
    if length(v) == 4
        if x < v[3]
            return balance(v[1], ins(v[2], x), v[3], v[4])
        elseif x > v[3]
            return balance(v[1], v[2], v[3], ins(v[4], x))
        end
    end
    v
end

ins(t, a) = [R, E, a, E]

insert(v, a) = (t = ins(v, a); t[1] = B; t)

function testRB()
    t = E
    for i in rand(collect(1:20), 10)
        t = insert(t, i)
    end
    println(replace(string(t), r"lackNode\(\)|edNode\(\)|Any|mpty\(\)" => ""))
end

testRB()
