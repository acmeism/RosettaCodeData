import Base.print

abstract type Entry end

mutable struct OutlineEntry <: Entry
    level::Int
    text::String
    parent::Union{Entry, Nothing}
    children::Vector{Entry}
end

mutable struct Outline
    root::OutlineEntry
    entries::Vector{OutlineEntry}
    baseindent::String
end

rootentry() = OutlineEntry(0, "", nothing, [])
indentchar(ch) = ch == ' ' || ch == '\t'
firsttext(s) = something(findfirst(!indentchar, s), length(s) + 1)
splitline(s) = begin i = firsttext(s); i == 1 ? ("", s) : (s[1:i-1], s[i:end]) end

const _indents = ["        "]

function Base.print(io::IO, oe::OutlineEntry)
    println(io, _indents[end]^oe.level, oe.text)
    for child in oe.children
        print(io, child)
    end
end

function Base.print(io::IO, o::Outline)
    push!(_indents, o.baseindent)
    print(io, o.root)
    pop!(_indents)
end

function firstindent(lines, default = "        ")
    for lin in lines
        s1, s2 = splitline(lin)
        s1 != "" && return s1
    end
    return default
end

function Outline(str::String)
    arr, lines = OutlineEntry[], filter(x -> x != "", split(str, r"\r\n|\n|\r"))
    root, indent, parentindex, lastindents = rootentry(), firstindent(lines), 0, 0
    if ' ' in indent && '\t' in indent
        throw("Mixed tabs and spaces in indent are not allowed")
    end
    indentlen, indentregex = length(indent), Regex(indent)
    for (i, lin) in enumerate(lines)
        header, txt = splitline(lin)
        indentcount = length(collect(eachmatch(indentregex, header)))
        (indentcount * indentlen < length(header)) &&
            throw("Error: bad indent " * string(UInt8.([c for c in header])) *
                ", expected " * string(UInt8.([c for c in indent])))
        if indentcount > lastindents
            parentindex = i - 1
        elseif indentcount < lastindents
            parentindex = something(findlast(x -> x.level == indentcount - 1, arr), 0)
        end
        lastindents = indentcount
        ent = OutlineEntry(indentcount, txt, parentindex == 0 ? root : arr[parentindex], [])
        push!(ent.parent.children, ent)
        push!(arr, ent)
    end
    return Outline(root, arr, indent)
end

function sorttree!(ent::OutlineEntry, rev=false, level=0)
    for child in ent.children
        sorttree!(child, rev)
    end
    if level == 0 || level == ent.level
        sort!(ent.children, lt=(x, y) -> x.text < y.text, rev=rev)
    end
    return ent
end

outlinesort!(ol::Outline, rev=false, lev=0) = begin sorttree!(ol.root, rev, lev); ol end

const outline4s = Outline("""
zeta
    beta
    gamma
        lambda
        kappa
        mu
    delta
alpha
    theta
    iota
    epsilon""")

const outlinet1 = Outline("""
zeta
    gamma
        mu
        lambda
        kappa
    delta
    beta
alpha
    theta
    iota
    epsilon""")

println("Given the text:\n", outline4s)
println("Sorted outline is:\n", outlinesort!(outline4s))
println("Reverse sorted is:\n", outlinesort!(outline4s, true))

println("Using the text:\n", outlinet1)
println("Sorted outline is:\n", outlinesort!(outlinet1))
println("Reverse sorted is:\n", outlinesort!(outlinet1, true))
println("Sorting only third level:\n", outlinesort!(outlinet1, false, 3))

try
    println("Trying to parse a bad outline:")
    outlinebad1 = Outline("""
alpha
    epsilon
	iota
    theta
zeta
    beta
    delta
    gamma
    	kappa
        lambda
        mu""")
catch y
    println(y)
end

try
    println("Trying to parse another bad outline:")
    outlinebad2 = Outline("""
zeta
    beta
   gamma
        lambda
         kappa
        mu
    delta
alpha
    theta
    iota
    epsilon""")
catch y
    println(y)
end
