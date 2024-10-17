import Base.show

mutable struct Asm32
    offset::Int32
    code::String
    arg::Int32
    targ::Int32
end
Asm32(code, arg = 0) = Asm32(0, code, arg, 0)

show(io::IO, a::Asm32) = print(io, lpad("$(a.offset)", 6), lpad(a.code, 8),
    a.targ > 0 ? (lpad("($(a.arg))", 8) * lpad("$(a.targ)", 4)) :
    (a.code in ["store", "fetch"] ? lpad("[$(a.arg)]", 8) :
    (a.code in ["push"] ? lpad("$(a.arg)", 8) : "")))

const ops32 = Dict{String,String}("Multiply" => "mul", "Divide" => "div", "Mod" => "mod", "Add" => "add",
    "Subtract" => "sub", "Less" => "lt", "Greater" => "gt", "LessEqual" => "le", "GreaterEqual" => "ge",
    "Equal" => "eq", "NotEqual" => "ne", "And" => "and", "or" => "or", "Not" => "not", "Minus" => "neg",
    "Prtc" => "prtc", "Prti" => "prti", "Prts" => "prts")

function compiletoasm(io)
    identifiers = Vector{String}()
    strings = Vector{String}()
    labels = Vector{Int}()

    function cpile(io, islefthandside = false)
        arr = Vector{Asm32}()
        jlabel() = (push!(labels, length(labels) + 1); labels[end])
        m = match(r"^(\w+|;)\s*([\d\w\"\\ \S]+)?", strip(readline(io)))
        x, val = m == nothing ? Pair(";", 0) : m.captures
        if x == ";" return arr
        elseif x == "Assign"
            lhs = cpile(io, true)
            rhs = cpile(io)
            append!(arr, rhs)
            append!(arr, lhs)
            if length(arr) > 100 exit() end
        elseif x == "Integer" push!(arr, Asm32("push", parse(Int32, val)))
        elseif x == "String"
            if !(val in strings)
                push!(strings, val)
            end
            push!(arr, Asm32("push", findfirst(x -> x == val, strings) - 1))
        elseif x == "Identifier"
            if !(val in identifiers)
                if !islefthandside
                    throw("Identifier $val referenced before it is assigned")
                end
                push!(identifiers, val)
            end
            push!(arr, Asm32(islefthandside ? "store" : "fetch", findfirst(x -> x == val, identifiers) - 1))
        elseif haskey(ops32, x)
            append!(arr, cpile(io))
            append!(arr, cpile(io))
            push!(arr, Asm32(ops32[x]))
        elseif x ==  "If"
            append!(arr, cpile(io))
            x, y = jlabel(), jlabel()
            push!(arr, Asm32("jz", x))
            append!(arr, cpile(io))
            push!(arr, Asm32("jmp", y))
            a = cpile(io)
            if length(a) < 1
                push!(a, Asm32("nop", 0))
            end
            a[1].offset = x
            append!(arr, a)
            push!(arr, Asm32(y, "nop", 0, 0)) # placeholder
        elseif x == "While"
            x, y = jlabel(), jlabel()
            a = cpile(io)
            if length(a) < 1
                push!(a, Asm32("nop", 0))
            end
            a[1].offset = x
            append!(arr, a)
            push!(arr, Asm32("jz", y))
            append!(arr, cpile(io))
            push!(arr, Asm32("jmp", x), Asm32(y, "nop", 0, 0))
        elseif x == "Sequence"
            append!(arr, cpile(io))
            append!(arr, cpile(io))
        else
            throw("unknown node type: $x")
        end
        arr
    end

    # compile AST
    asmarr = cpile(io)
    push!(asmarr, Asm32("halt"))
    # move address markers to working code and prune nop code
    for (i, acode) in enumerate(asmarr)
        if acode.code == "nop" && acode.offset != 0 && i < length(asmarr)
            asmarr[i + 1].offset = asmarr[i].offset
        end
    end
    filter!(x -> x.code != "nop", asmarr)
    # renumber offset column with actual offsets
    pos = 0
    jmps = Dict{Int, Int}()
    for acode in asmarr
        if acode.offset > 0
            jmps[acode.offset] = pos
        end
        acode.offset = pos
        pos += acode.code in ["push", "store", "fetch", "jz", "jmp"] ? 5 : 1
    end
    # fix up jump destinations
    for acode in asmarr
        if acode.code in ["jz", "jmp"]
            if haskey(jmps, acode.arg)
                acode.targ = jmps[acode.arg]
                acode.arg = acode.targ - acode.offset -1
            else
                throw("unknown jump location: $acode")
            end
        end
    end
    # print Datasize and Strings header
    println("Datasize: $(length(identifiers)) Strings: $(length(strings))\n" *
        join(strings, "\n") )
    # print assembly lines
    foreach(println, asmarr)
end

const testAST = raw"""
Sequence
Sequence
;
Assign
Identifier    count
Integer       1
While
Less
Identifier    count
Integer       10
Sequence
Sequence
;
Sequence
Sequence
Sequence
;
Prts
String        "count is: "
;
Prti
Identifier    count
;
Prts
String        "\n"
;
Assign
Identifier    count
Add
Identifier    count
Integer       1    """

iob = IOBuffer(testAST) # use an io buffer here for testing, but could use stdin instead of iob

compiletoasm(iob)
