using Humanize

function sizelist(path::AbstractString)
    rst = Vector{Int}(0)
    for (root, dirs, files) in walkdir(path)
        files = joinpath.(root, files)
        tmp = collect(filesize(f) for f in files if !islink(f))
        append!(rst, tmp)
    end
    return rst
end

byclass(y, classes) = Dict{eltype(classes),Int}(c => count(c[1] .≤ y .< c[2]) for c in classes)

function main(path::AbstractString)
    s = sizelist(path)
    cls = append!([(0, 1)], collect((10 ^ (i-1), 10 ^ i) for i in 1:9))
    f = byclass(s, cls)

    println("filesizes: ")
    for c in cls
        @printf(" - between %8s and %8s bytes: %3i\n", datasize(c[1]), datasize(c[2]), f[c])
    end
    println("\n-> total: $(datasize(sum(s))) bytes and $(length(s)) files")
end

main(".")
