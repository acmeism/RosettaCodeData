#!/usr/bin/env julia

const prgm = basename(Base.source_path())

if length(ARGS) < 2
    println("usage: ", prgm, " <file> [line]...")
    exit(1)
end

file = ARGS[1]

const numbers = map(x -> begin
    try
        parse(Uint, x)
    catch
        println(prgm, ": ", x, ": not a number")
        exit(1)
    end
end, ARGS[2:end])

f = open(file)
lines = readlines(f)
close(f)

if maximum(numbers) > length(lines)
    println(prgm, ": detected extraneous line number")
    exit(1)
end

deleteat!(lines, sort(unique(numbers)))
f = open(file, "w")
write(f, join(lines))
close(f)
