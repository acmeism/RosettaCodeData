using Combinatorics

const pairs = [
    "alliance" => -624, "archbishop" => -915, "balm" => 397, "bonnet" => 452,
    "brute" => 870, "centipede" => -658, "cobol" => 362, "covariate" => 590,
    "departure" => 952, "deploy" => 44, "diophantine" => 645, "efferent" => 54,
    "elysee" => -326, "eradicate" => 376, "escritoire" => 856, "exorcism" => -983,
    "fiat" => 170, "filmy" => -874, "flatworm" => 503, "gestapo" => 915,
    "infra" => -847, "isis" => -982, "lindholm" => 999, "markham" => 475,
    "mincemeat" => -880, "moresby" => 756, "mycenae" => 183, "plugging" => -266,
    "smokescreen" => 423, "speakeasy" => -745, "vein" => 813]
const weights = [v for (k, v) in pairs]
const weightkeyed = Dict(Pair(v, k) for (k, v) in pairs)

function zerosums()
    total = 0
    for i in 1:length(weights)
        print("\nFor length $i: ")
        sets = [a for a in combinations(weights, i) if sum(a) == 0]
        if (n = length(sets)) == 0
            print("None")
        else
            total += n
            print("$n sets, example: ", map(x -> weightkeyed[x], rand(sets)))
        end
    end
    println("\n\nGrand total sets: $total")
end

zerosums()
