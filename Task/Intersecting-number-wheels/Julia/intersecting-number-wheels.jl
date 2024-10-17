const d1 = Dict("A" => [["1", "2", "3"], 1])
const d2 = Dict("A" => [["1", "B", "2"], 1], "B" => [["3", "4"], 1])
const d3 = Dict("A" => [["1", "D", "D"], 1], "D" => [["6", "7", "8"], 1])
const d4 = Dict("A" => [["1", "B", "C"], 1], "B" => [["3", "4"], 1],
    "C" => [["5", "B"], 1])

function getvalue!(wheelname, allwheels)
    wheel = allwheels[wheelname]
    s = wheel[1][wheel[2]]
    wheel[2] = mod1(wheel[2] + 1, length(wheel[1]))
    return haskey(allwheels, s) ? getvalue!(s, allwheels) : s
end

function testwheels(wheels, numterms = 20, firstwheel = "A")
    println("\nNumber Wheels:")
    for k in sort(collect(keys(wheels)))
        print("$k: [")
        for s in wheels[k][1]
            print(s, " ")
        end
        println("\b]")
    end
    print("Output: ")
    for _ in 1:numterms
        print(getvalue!(firstwheel, wheels), " ")
    end
    println("...")
end

foreach(testwheels, [d1, d2, d3, d4])
