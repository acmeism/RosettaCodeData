""" Rosetta Code task rosettacode.org/wiki/VList """

import Base.length, Base.string

using BenchmarkTools

abstract type VNode end

struct VNil <: VNode end
const nil = VNil()

mutable struct VSeg{T} <: VNode
    next::VNode
    ele::Vector{T}
end

mutable struct VList
    base::VNode
    offset::Int
    VList(b = nil, o = 0) = new(b, o)
end

""" primary operation 1: locate the kth element. """
function index(v, i)
    i < 0 && error("index out of range")
    i += v.offset
    sg = v.base
    while sg !== nil
        i < length(sg.ele) && return sg.ele[i + 1]
        i -= length(sg.ele)
        sg = sg.next
    end
end

""" primary operation 2: add an element to the front of the VList. """
function cons(v::VList, a)
    v.base === nil && return VList(VSeg(nil, [a]), 0)
    if v.offset == 0
        newlen = length(v.base.ele) * 2
        ele = Vector{typeof(a)}(undef, newlen)
        ele[newlen] = a
        return VList(VSeg(v.base, ele), newlen - 1)
    end
    v.base.ele[v.offset] = a
    v.offset -= 1
    return v
end

""" primary operation 3: obtain new array beginning at second element of old array """
function cdr(v)
    v.base === nil && error("cdr on empty VList")
    v.offset += 1
    return v.offset < length(v.base.ele) ? v : VList(v.base.next, 0)
end

""" primary operation 4:  compute the length of the list.  (It's O(1).) """
Base.length(v::VList) = (v.base === nil) ? 0 : length(v.base.ele) * 2 - v.offset - 1

""" A handy method:  satisfy string interface for easy output. """
function Base.string(v::VList)
    v.base === nil && return "[]"
    r = "[" * string(v.base.ele[v.offset+1])
    sg, sl = v.base, v.base.ele[v.offset+2:end]
    while true
        r *= " " * join(sl, " ")
        sg = sg.next
        sg === nil && break
        sl = sg.ele
    end
    return r * "]"
end

""" Basic print for VList """
Base.print(io::IO, v::VList) = print(io, string(v))

""" One more method for demonstration purposes """
function print_structure(v::VList)
    println("offset: ", v.offset)
    sg = v.base
    while sg !== nil
        println("  $(sg.ele)") # illustrates the string type
        sg = sg.next
    end
    println()
end

""" demonstration program using the WP example data """
function testVList()
    v = VList()
    println("zero value for type.  empty VList: $v")
    print_structure(v)

    for a in '6':-1:'1'
        v = cons(v, a)
    end
    println("demonstrate cons. 6 elements added: $v")
    print_structure(v)

    v = cdr(v)
    println("demonstrate cdr. 1 element removed: $v")
    print_structure(v)

    println("demonstrate length. length = ", length(v), "\n")

    println("demonstrate element access. v[3] = ", index(v, 3), "\n")

    v = v |> cdr |> cdr
    println("show cdr releasing segment. 2 elements removed: $v")
    print_structure(v)

    # Timings for n = 10, 100, 1000, 1000 sized structures

    for i in 1:4
        v = VList()
        c = Char[]
        for a in 10^i:-1:1
            v = cons(v, a)
            push!(c, a)
        end
        println("Testing index for VList of size ", 10^i)
        arr = rand(1:10^i-1, 100)
        @btime let
            n = 0
            for k in $arr
                n = index($v, k)
            end
        end
        println("Testing index for vector of size ", 10^i)
        @btime let n = 0
            for k in $arr
                n = $c[k]
            end
        end
        println("Testing adding an element for VList of size ", 10^i)
        @btime let n = cons($v, 0) end
        println("Testing adding an element for vector of size ", 10^i)
        @btime let n = push!($c, '\0') end

        println("Testing new array beginning at second element for VList of size ", 10^i)
        @btime let m = cdr($v) end
        println("Testing new vector with copy beginning at second element for vector of size ", 10^i)
        @btime let m = popfirst!(copy($c)) end
        println("Testing new vector using a view beginning at second element for vector of size ", 10^i)
        @btime let m = @view $c[2:end] end

        println("Testing length for VList of size ", 10^i)
        @btime let n = length($v) end
        println("Testing length for vector of size ", 10^i)
        @btime let n = length($c) end
    end
end

testVList()
