function main()
    # ratings on past form, assuming a rating of 100 for horse A
    a = 100
    b = a - 8 - 2*2 # carried 8 lbs less, finished 2 lengths behind
    c = a + 4 - 2*3.5
    d = a - 4 - 10*0.4 # based on relative weight and time
    e = d + 7 - 2*1
    f = d + 11 - 2*(4-2)
    g = a - 10 + 10*0.2
    h = g + 6 - 2*1.5
    i = g + 15 - 2*2

    # adjustments to ratings for current race
    b += 4
    c -= 4
    h += 3
    j = a - 3 + 10*0.2

    # filly's allowance to give weight adjusted weighting
    b += 3
    d += 3
    i += 3
    j += 3

    # create vector of pairs of horse to pair of weight adjusted rating and whether colt (1 == yes, 0 == no)
    m = ["A" => a => 1,
         "B" => b => 0,
         "C" => c => 1,
         "D" => d => 0,
         "E" => e => 1,
         "F" => f => 1,
         "G" => g => 1,
         "H" => h => 1,
         "I" => i => 0,
         "J" => j => 0]

    # sort in descending order of rating
    sort!(m, lt = (x, y) -> first(last(x)) > first(last(y)))

    # show expected result of race
    println("Race 4\n")
    println("Pos Horse  Weight  Dist  Sex")
    pos = ""
    for x in eachindex(m)
        wt = last(last(m[x])) == 0 ? "8.11" : "9.00"
        dist = x == 1 ? 0.0 : (first(last(m[x - 1])) - first(last(m[x]))) * 0.5
        if x == 1 || dist > 0.0
            pos = "$x"
        elseif !occursin("=", pos)
            pos = "$(x - 1)="
        end
        sx = last(last(m[x])) == 0 ? "filly" : "colt"
        println(rpad(pos, 4), rpad(first(m[x]), 7), rpad(wt, 8), rpad(round(dist, digits=1), 6), sx)
    end

    # expected time of winner (relative to A's weight adjusted time rating in first race)
    t = 96.0 - (first(last(first(m))) - 100) / 10
    min, sec = divrem(t, 60.0)
    println("\nTime $min minutes and ", round(sec, digits=1), " seconds.")
end

main()
