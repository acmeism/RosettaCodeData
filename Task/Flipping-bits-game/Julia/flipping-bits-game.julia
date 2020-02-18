module FlippingBitsGame

using Printf, Random
import Base.size, Base.show, Base.==

struct Configuration
    M::BitMatrix
end

Base.size(c::Configuration) = size(c.M)
function Base.show(io::IO, conf::Configuration)
    M = conf.M
    nrow, ncol = size(M)
    print(io, " " ^ 3)
    for c in 1:ncol
        @printf(io, "%3i", c)
    end
    println(io, "\n", " " ^ 4, "-" ^ 3ncol)
    for r in 1:nrow
        @printf(io, "%2i |", r)
        for c in 1:ncol
            @printf(io, "%2c ", ifelse(M[r, c], 'T', 'F'))
        end
        println(io)
    end
    return nothing
end
Base.:(==)(a::Configuration, b::Configuration) = a.M == b.M

struct Index{D}
    i::Int
end
const ColIndex = Index{:C}
const RowIndex = Index{:R}

function flipbits!(conf::Configuration, c::ColIndex)
    col = @view conf.M[:, c.i]
    @. col = !col
    return conf
end
function flipbits!(conf::Configuration, r::RowIndex)
    row = @view conf.M[r.i, :]
    @. row = !row
    return conf
end

randomconfig(nrow::Integer, ncol::Integer) = Configuration(bitrand(nrow, ncol))

function randommoves!(conf::Configuration, nflips::Integer)
    nrow, ncol = size(conf)
    for _ in Base.OneTo(nflips)
        if rand() < 0.5
            flipbits!(conf, ColIndex(rand(1:ncol)))
        else
            flipbits!(conf, RowIndex(rand(1:nrow)))
        end
    end
    return conf
end

function play()
    nrow::Int, ncol::Int = 0, 0
    while nrow < 2 || ncol < 2
        print("Insert the size of the matrix (nrow [> 1] *space* ncol [> 1]):")
        nrow, ncol = parse.(Int, split(readline()))
    end
    mat = randomconfig(nrow, ncol)
    obj = deepcopy(mat)
    randommoves!(obj, 100)
    nflips = 0
    while mat != obj
        println("\n", nflips, " flips until now.")
        println("Current configuration:")
        println(mat)
        println("Objective configuration:")
        println(obj)
        print("Insert R[ind] to flip row, C[ind] to flip a column, Q to quit: ")
        line  = readline()
        input = match(r"([qrc])(\d+)"i, line)
        if input ≢ nothing && all(input.captures .≢ nothing)
            dim = Symbol(uppercase(input.captures[1]))
            ind = Index{dim}(parse(Int, input.captures[2]))
            flipbits!(mat, ind)
            nflips += 1
        elseif occursin("q", line)
            println("\nSEE YOU SOON!")
            return
        else
            println("\nINPUT NOT VALID, RETRY!\n")
        end
    end
    println("\nSUCCED! In ", nflips, " flips.")
    println(mat)
    return
end

end  # module FlippingBitsGame

using .FlippingBitsGame

FlippingBitsGame.play()
