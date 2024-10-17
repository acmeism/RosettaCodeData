hello()   = println("Hello, world!")
quine()   = println(src)
bottles() = for i = 99:-1:1 print("\n$i bottles of beer on the wall\n$i bottles of beer\nTake one down, pass it around\n$(i-1) bottles of beer on the wall\n") end
acc = 0
incr()    = global acc += 1

const dispatch = Dict(
'h' => hello,
'q' => quine,
'9' => bottles,
'+' => incr)

if length(ARGS) < 1
    println("Usage: julia ./HQ9+.jl file.hq9")
    exit(1)
else
    file = ARGS[1]
end

try
    open(file) do s
        global src = readstring(s)
    end
catch
    warning("can't open $file")
    exit(1)
end

for i in lowercase(src)
    if haskey(dispatch, i) dispatch[i]() end
end
