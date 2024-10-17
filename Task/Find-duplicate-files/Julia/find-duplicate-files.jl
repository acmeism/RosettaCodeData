using Printf, Nettle

function find_duplicates(path::String, minsize::Int = 0)
    filesdict = Dict{String,Array{NamedTuple}}()

    for (root, dirs, files) in walkdir(path), fn in files
        filepath = joinpath(root, fn)
        filestats = stat(filepath)

        filestats.size > minsize || continue

        hash = open(f -> hexdigest("md5", read(f)), filepath)

        if haskey(filesdict, hash)
            push!(filesdict[hash], (path = filepath, stats = filestats))
        else
            filesdict[hash] = [(path = filepath, stats = filestats)]
        end
    end

    # Get duplicates
    dups = [tups for tups in values(filesdict) if length(tups) > 1]

    return dups

end

function main()
    path = "."
    println("Finding duplicates in \"$path\"")
    dups = find_duplicates(".", 1)

    println("The following group of files have the same size and the same hash:\n")
    println("File name                                       Size   last modified")
    println("="^76)

    for files in sort(dups, by = tups -> tups[1].stats.size, rev = true)
        for (path, stats) in sort(files, by = tup -> tup.path, rev = true)
            @printf("%-44s%8d   %s\n", path, stats.size, Libc.strftime(stats.mtime))
        end
        println()
    end
end

main()
