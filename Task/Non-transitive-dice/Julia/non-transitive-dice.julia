import Base.>, Base.<
using Memoize, Combinatorics

struct Die
    name::String
    faces::Vector{Int}
end

""" Compares two die returning 1, -1 or 0 for operators >, < == """
function cmpd(die1, die2)
    # Numbers of times one die wins against the other for all combinations
    # cmp(x, y) is `(x > y) - (y > x)` to return 1, 0, or -1 for numbers
    tot = [0, 0, 0]
    for d in Iterators.product(die1.faces, die2.faces)
        tot[2 + (d[1] > d[2]) - (d[2] > d[1])] += 1
    end
    return (tot[3] > tot[1]) - (tot[1] > tot[3])
end

Base.:>(d1::Die, d2::Die) = cmpd(d1, d2) == 1
Base.:<(d1::Die, d2::Die) = cmpd(d1, d2) == -1

""" True iff ordering of die in dice is non-transitive """
isnontrans(dice) = all(x -> x[1] < x[2], zip(dice[1:end-1], dice[2:end])) && dice[1] > dice[end]

findnontrans(alldice, n=3) = [perm for perm in permutations(alldice, n) if isnontrans(perm)]

function possible_dice(sides, mx)
    println("\nAll possible 1..$mx $sides-sided dice")
    dice = [Die("D $(n+1)", [i for i in f]) for (n, f) in
        enumerate(Iterators.product(fill(1:mx, sides)...))]
    println("  Created $(length(dice)) dice")
    println("  Remove duplicate with same bag of numbers on different faces")
    uniquedice = collect(values(Dict(sort(d.faces) => d for d in dice)))
    println("   Return $(length(uniquedice)) filtered dice")
    return uniquedice
end

""" Compares two die returning their relationship of their names as a string """
function verbosecmp(die1, die2)
    # Numbers of times one die wins against the other for all combinations
    win1 = sum(p[1] > p[2] for p in Iterators.product(die1.faces, die2.faces))
    win2 = sum(p[2] > p[1] for p in Iterators.product(die1.faces, die2.faces))
    n1, n2 = die1.name, die2.name
    return win1 > win2 ? "$n1 > $n2" : win1 < win2 ? "$n1 < $n2" : "$n1 = $n2"
end

""" Dice cmp function with verbose extra checks """
function verbosedicecmp(dice)
    return join([[verbosecmp(x, y) for (x, y) in zip(dice[1:end-1], dice[2:end])];
                 [verbosecmp(dice[1], dice[end])]], ", ")
end

function testnontransitivedice(faces)
    dice = possible_dice(faces, faces)
    for N in (faces < 5 ? [3, 4] : [3])  # length of non-transitive group of dice searched for
        nontrans = unique(map(x -> sort!(x, lt=(x, y)->x.name<y.name), findnontrans(dice, N)))
        println("\n  Unique sorted non_transitive length-$N combinations found: $(length(nontrans))")
        for list in (faces < 5 ? nontrans : [nontrans[end]])
            println(faces < 5 ? "" : "  Only printing last example for brevity")
            for (i, die) in enumerate(list)
                println("     $die$(i < N - 1 ? "," : "]")")
            end
        end
        if !isempty(nontrans)
            println("\n  More verbose comparison of last non_transitive result:")
            println(" ", verbosedicecmp(nontrans[end]))
        end
        println("\n  ====")
    end
end

@time testnontransitivedice(3)
@time testnontransitivedice(4)
@time testnontransitivedice(5)
@time testnontransitivedice(6)
