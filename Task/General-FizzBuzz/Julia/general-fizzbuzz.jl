function fizzbuzz(triggers :: Vector{Tuple{Int, ASCIIString}}, upper :: Int)
    for i = 1 : upper
        triggered = false

        for trigger in triggers
            if i % trigger[1] == 0
                triggered = true
                print(trigger[2])
            end
        end

        !triggered && print(i)
        println()
    end
end

print("Enter upper limit:\n> ")
upper = parse(Int, readline())

triggers = Tuple{Int, ASCIIString}[]
print("Enter factor/string pairs (space delimited; ^D when done):\n> ")
while (r = readline()) != ""
    input = split(r)
    push!(triggers, (parse(Int, input[1]), input[2]))
    print("> ")
end

println("EOF\n")
fizzbuzz(triggers, upper)
