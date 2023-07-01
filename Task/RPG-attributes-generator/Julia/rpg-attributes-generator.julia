roll_skip_lowest(dice, sides) = (r = rand(collect(1:sides), dice); sum(r) - minimum(r))

function rollRPGtoon()
    attributes = zeros(Int, 6)
    attsum = 0
    gte15 = 0

    while attsum < 75 || gte15 < 2
        for i in 1:6
            attributes[i] = roll_skip_lowest(4, 6)
        end
        attsum = sum(attributes)
        gte15 = mapreduce(x -> x >= 15, +, attributes)
    end

    println("New RPG character roll: $attributes. Sum is $attsum, and $gte15 are >= 15.")
end

rollRPGtoon()
rollRPGtoon()
rollRPGtoon()
